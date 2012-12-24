require 'hashie/mash'
module Ablerc
  class Context
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

      def method_missing(method_name, *args, &block)
        @@contexts.send(method_name, *args, &block) || super
      end

      def paths
        @@contexts.collect { |name, context| context.path }
      end

      def exists?(context)
        @@contexts.has_key? context
      end
    end
  end
end
