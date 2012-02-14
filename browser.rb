require 'dnssd'
require 'uri'

def stop
  puts "Exit"
  exit
end

trap('INT') {stop}
trap('TERM'){stop}

Thread.abort_on_exception = true
thread = Thread.new do
  browser = DNSSD::Service.new

  services = {}

  puts "Browsing for TCP DJJour service"
  puts

  browser.browse '_djjour._tcp' do |reply|
    services[reply.fullname] = reply


    next if reply.flags.more_coming?

    services.sort_by do |_, service|
      [(service.flags.add? ? 0 : 1), service.fullname]
    end.each do |_, service|
      add = service.flags.add? ? 'Add' : 'Remove'


      puts "#{add} #{service.name} on #{service.domain}"
    end

    DNSSD.resolve reply.name, reply.type, reply.domain do |resolve_reply|
      puts resolve_reply.name

      if reply.flags.add?
        puts "Added"
      else
        puts "Removed"
      end

      uri = URI.parse("http://#{resolve_reply.target}:#{resolve_reply.port}")
      puts uri.to_s

      puts "Resolved: #{resolve_reply.inspect} - #{resolve_reply.service.started?}"
    end


    services.clear

    puts
  end
end

thread.join
