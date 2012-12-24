require 'hashie/dash'
module Ablerc
  # An option is a declared attribute within an rc file,
  # in other words, an uncommented key-value pair.
  #
  # Options define how an attribute behaves (via behavior
  # parameters), which are used to validate, explain and 
  # control default values for the option.
  class Option < Hashie::Dash
    property :name, :required => true
    property :behaviors

    # Initialize the option
    # 
    # ==== Parameters
    # * <tt>name</tt>  - A valid name for the option
    # * <tt>behaviors</tt>  - Behaviors used to for this option
    # * <tt>block</tt>   - A proc that should be run against the option value.
    # ==== Options
    # * <tt>allow</tt>  - The option value must be in this list
    # * <tt>boolean</tt>  - The option will accept <tt>true</tt>, <tt>false</tt>, <tt>0</tt>, <tt>1</tt>
    def initialize(name, behaviors = {}, &block)
        self.name = name
    end
  end
end
