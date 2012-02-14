require 'resque/tasks'

task 'resque:setup' => :environment do
  Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
end

task :work => 'resque:setup' do
  ENV['VERBOSE'] ||= 'false'
  ENV['QUEUE'] ||= SongKick::Worker.queues.join(',')
  ENV['INTERVAL'] ||= '1'

  Resque.redis = ENV['REDIS_URL'] || 'localhost'

  puts "Starting worker in #{Rails.env} environment"
  Rake.application['resque:work'].execute
end

