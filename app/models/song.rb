class Song < ActiveRecord::Base
  belongs_to  :artist
  belongs_to  :album
  has_many    :votes, :dependent => :destroy
  has_many    :tracks

  scope :queue, select("songs.*,(select count(song_id) from votes where song_id=songs.id and active='t') as song_count").
              where(:queued => true).
              order("song_count desc, updated_at")

  scope :playing, where(:now_playing => true).first

  # Queue up a song.
  #
  #   user - the User who is requesting the song to be queued
  #
  # Returns the result of the user's vote for that song.
  def enqueue!(user)
    self.queued = true
    save
    download
    user.vote_for(self)
  end

  # Remove a song from the queue
  #
  #   user - the User who is requesting the song be removed
  #
  # Returns true if removed properly, false otherwise.
  def dequeue!(user=nil)
    update_attribute(:queued, false)
  end

  # Update the metadata surrounding playing a song.
  #
  # Returns a Boolean of whether we've saved the song.
  def play!
    Song.update_all(:now_playing => false)
    self.now_playing    = true
    self.last_played_at = Time.now
    votes.update_all(:active => false)
    save
  end

  def playing?
    now_playing.eql?(true)
  end

  # Plays the next song in the queue. Updates the appropriate metainformation
  # in surrounding tables. Will pull an office favorite if there's nothing in
  # the queue currently.
  #
  # Returns the Song that was selected next to be played.
  def self.play_next_in_queue
    song = queue.first
    return nil unless song
    song.play!
    song.increment!(:playcount)
    song.dequeue!
    song.reload
    song
  end

  # Enqueues a download job to fetch the actual file from any library it can find with
  # this song
  #
  # If no library can be found with this song we dequeue it, keeping votes in place
  # for next time.
  #
  # Returns nothing
  def download
    track = tracks.joins(:library).where(:libraries => {:online => true}).first
    if track
      DownloadWorker.enqueue(:url => track.url, :song_id => self.id)
    else
      dequeue!
    end
  end
end

