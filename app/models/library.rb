class Library < ActiveRecord::Base
  has_many :tracks

  def self.create_or_update_from_dnssd_service(service)
    library = find_or_create_by_name(service.name)

    if service.flags.add?
      DNSSD::Service.new.resolve service do |r|
        # puts service.domain
        uri = URI.parse("http://#{r.target}:#{r.port}")
        puts uri.host

        if uri.host =~ /\.local\.?$/
          library.update_attribute(:url, uri.to_s)

          library.update_attribute(:online, true)
          library.import
        end
        break unless r.flags.more_coming?
      end
    else
      library.update_attribute(:online, false)
    end
  end

  def self.add(hostname, ip_address)
    library = find_or_create_by_name(hostname)
    library.update_attributes(:online => true, :url => ip_address)
    library.import
    puts "ADD: #{library}"
  end

  def self.remove(hostname)
    library = find_or_create_by_name(hostname)
    library.update_attributes(:online => false)
    puts "REMOVE: #{library}"
  end

  def to_s
    name
  end

  def load_json
    json = RestClient.get(self.url)
    JSON.load(json)
  end

  def import
    print "Importing library from #{url}..."
    library_hash = load_json

    tracks_array = library_hash['tracks'].map { |track|
      track = sanitize_keys(track)
      track.symbolize_keys!
      track = track.slice(*SongKick::TrackHash.translations)
      SongKick::TrackHash.new(track)
    }

    tracks_array.each do |track_hashie|
      unless track_hashie.artist.blank?
        track = tracks.find_or_create_by_persistent_id(track_hashie.persistent_id)
        track.attributes = track_hashie.to_hash.symbolize_keys.slice(:guid, :bit_rate)

        artist = Artist.find_or_create_by_name(track_hashie.artist)
        track.song = Song.find_or_create_by_title(track_hashie.name, :artist => artist)
        track.save!
      end
    end

    update_attributes(:imported_at => Time.now)

    puts "Done. Imported #{tracks.count} tracks."
  rescue Errno::ETIMEDOUT, Errno::ECONNREFUSED => e
    puts "ERROR: Connection timed out"
    update_attribute(:online, false)
  end

  def online?
    online.eql?(true)
  end

  def sanitize_keys(hash)
    result = {}
    hash.each { |key, value|
      result[key.to_s.gsub(/ /, '_')] = value
    }
    result
  end

end
