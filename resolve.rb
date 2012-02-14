require 'dnssd'

Thread.abort_on_exception = true
trap 'INT' do exit end
trap 'TERM' do exit end

class Browser
  def add(reply)
    puts reply.name
    puts address(resolve(reply))
  end

  def remove(reply)
    puts "Remove: #{reply}"
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
        add reply
      else
        remove reply
      end
    end
  end
end

Browser.new.browse
sleep

