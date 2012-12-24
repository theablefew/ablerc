module Ablerc
  class DSL
    # The name of the file to be used for the configuration of this app
    # Include a dot if you expect hidden file behavior. 
    def rc_file_name(file_name)
      puts "RC_FILE #{file_name}".color :green
      Ablerc.rc_file_name = file_name
    end

    # Describes the order in which configuration files are loaded.
    # Default is <tt>:global</tt>, <tt>:user</tt>, <tt>:local</tt> which
    # will search for <tt>rc_file_name</tt> in these directories:
    #   /etc/.ablerc
    #   ~/.ablerc
    #  ./.ablerc
    #
    # Configuration options cascade and override previously loaded options.
    # scheme :global, :user, :local
    def scheme(*contexts)
      Ablerc.scheme = contexts
    end

    # Describe the options available
    #
    # ==== Parameters
    # * <tt>name</tt>  - A valid name for the option
    # * <tt>behaviors</tt>  - Behaviors used to for this option
    # * <tt>block</tt>   - A proc that should be run against the option value.
    # ==== Options
    # * <tt>allow</tt>  - The option value must be in this list
    # * <tt>boolean</tt>  - The option will accept <tt>true</tt>, <tt>false</tt>, <tt>0</tt>, <tt>1</tt>
    def option(name, behaviors = {}, &block)
      Ablerc.options << Ablerc::Option.new(name, behaviors, &block)
    end

    def context(name, options)
      Ablerc::Context.new(name, options)
    end

    def method_missing(method_name, *args, &block)
      msg = "You tried to call the method #{method_name}. There is no such method."
      raise msg
    end

    def respond_to? *args; super; end
  end
end