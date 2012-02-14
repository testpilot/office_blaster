class Album < ActiveRecord::Base
  belongs_to :album
  has_many :songs, :dependent => :destroy

  # Queue up an entire ALBUM!
  #
  #   user - the User who is requesting the album to be queued
  #
  # Returns nothing.
  def enqueue!(user)
    songs.each{ |song| song.enqueue!(user) }
  end

end
