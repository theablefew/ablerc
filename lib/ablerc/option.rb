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
    attr_accessor :allows, :refuses, :boolean, :description, :default, :disabled

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
        extract_behaviors( behaviors )
    end


    def to_stub
      stub = "## #{name}\n"
      stub << "# #{description}\n" unless description.nil?
      stub << "#{entry_for_refuse_allow_behavior}\n" unless refuses.nil? and allows.nil?
      stub << "#{entry_for_key_value}\n"
      stub << "\n"
    end

    private

    def entry_for_key_value
      line = ""
      line << "# Default: #{default}\n" unless default.nil?
      line << "#" if disabled
      line << "#{name} = "
      line << default unless default.nil?
      line
    end


    def entry_for_boolean
      line = ""
      line << "# Accepts boolean values of true, false, 0 or 1" unless boolean.nil?
      line
    end


    def entry_for_refuse_allow_behavior
      line = ""
      line << "# Allows \n# #{allows.join(',')}" unless allows.nil?
      line << "# Refuses \n# #{refuses.join(',')}" unless refuses.nil?
      line
    end

    def extract_behaviors(behaviors)
      behaviors.tap do |b|
        self.allows        = b.delete :allow
        self.refuses       = b.delete :refuses
        self.boolean       = b.delete :boolean
        self.description   = b.delete :description
        self.default       = b.delete :default
        self.disabled      = b.delete(:disabled) || true
      end
    end
  end
end
