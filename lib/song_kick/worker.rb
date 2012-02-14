require 'resque/plugins/meta'

module SongKick
  class Worker
    extend Resque::Plugins::Meta

    class_attribute :worker_subclasses
    self.worker_subclasses = []

    class << self
      def inherited(worker)
        self.worker_subclasses << worker
      end

      def queues
        Dir[File.join(File.dirname(__FILE__), 'workers', '*_worker.rb')].each { |worker| require worker }
        self.worker_subclasses.map { |worker| worker.respond_to?(:queue) ? worker.queue : nil }.compact
      end

      def queue
        name.underscore.gsub(/\_/, '.')
      end

      def perform(meta_id, payload = {})
        new(meta_id, payload).perform
      end
    end


    attr_reader :payload, :meta_id

    def initialize(meta_id, payload = {})
      @payload = Hashr.new(payload)
      @meta_id = meta_id
      setup
    end

    def guid
      @meta_id[0,20]
    end

    def setup

    end

    def perform
      raise NotImplementedError, "You need to subclass #perform"
    end
  end
end
