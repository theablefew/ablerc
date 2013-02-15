require 'hashie/mash'
module Ablerc
  class Context

    DEFAULTS = {:global => {:path => '/etc/'},
                :user => {:path => '~/'},
                :local => {:path => './'}}


    attr_accessor :path, :name


    def initialize(name, options={})
      @name = name
      @path = options.delete(:path)
      Ablerc::Context << self
    end


    class << self

      @@contexts = Hashie::Mash.new


      def <<(context)
        @@contexts.merge!(context.name => context)
      end


      def paths
        @@contexts.collect { |name, context| context.path }
      end


      def list
        @@contexts
      end

      def names
        @@contexts.keys
      end


      def exists?(context)
        @@contexts.has_key? context
      end

      def method_missing(method_name, *args, &block)
        @@contexts.send(method_name, *args, &block) || super
      end
    end
  end
end
