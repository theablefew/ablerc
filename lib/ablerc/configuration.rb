require 'hashie/mash'
require 'singleton'

module Ablerc
  # Represents an rc file which consists
  # of a series of key value pairs
  class Configuration
    include Singleton
    attr_accessor :store


    class << self
      def load(path); self.instance.load(path); end
    end


    def read_values(&rc_file)
      rc_file.call
      yield(self)
    end


    def initialize
      @store ||= Hashie::Mash.new
    end


    def method_missing(method, *args, &block)
       store.send(method, *args, &block)
    end


    def load(path)
      return unless File.exists? path
      self.instance_eval do
        File.read(File.expand_path(path)).each_line do |line|
          next if line =~ /^[?\s]*\#/ || line.blank?
          store.instance_eval("self."+line)
        end
      end
    end
  end
end
