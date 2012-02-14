class DownloadWorker < SongKick::Worker

  def perform
    url = payload.url
    # curl http://10.0.1.193:1337/tracks/946/file -o ./tmp/song.mp3

    path = Rails.root.join('tmp', guid)

    `curl #{url} -o #{path}`
    song.update_attributes!(:path => path.to_s)
  end

  def song
    @song ||= Song.find(payload.song_id)
  end

end
