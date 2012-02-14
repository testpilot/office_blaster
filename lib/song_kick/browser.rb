require 'dnssd'
require "uri"

module SongKick
  class Browser

    def initialize
      trap('INT') { exit }
      trap('TERM'){ exit }
      puts "Waiting for DJJour libraries..."
      browse
    end

    def add(reply)
      resolved_reply = resolve(reply)
      hostname    = reply.name
      ip_address  = address(resolved_reply)
      port        = resolved_reply.port

      url = URI.parse("http://#{ip_address}:#{port}")
      Library.add(hostname, url.to_s)
    end

    def remove(reply)
      hostname    = reply.name
      Library.remove(hostname)
    end

    def resolve(reply)
      value = nil

      DNSSD.resolve! reply do |reply|
        value = reply
        break
      end
      return value
    end

    def address(reply)
      service = DNSSD::Service.new

      service.getaddrinfo reply.target do |addrinfo|
        address = addrinfo.address

        begin
          return address
        rescue
          next if addrinfo.flags.more_coming?
          raise
        end
      end
    end

    def browse
      DNSSD.browse '_djjour._tcp', 'local' do |reply|
        if reply.flags.add?
          begin
            add reply
          rescue => e
            puts [e.class.name, e.message].join(": ")
            next
          end
        else
          begin
            remove reply
          rescue => e
            puts "Remove ERROR: #{e.message}"
            next
          end
        end
      end
      sleep
    end
  end
end
