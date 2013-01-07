require "ablerc/version"
require "active_support/core_ext"
require "rainbow"

module Ablerc
  autoload :Option,           'ablerc/option'
  autoload :DSL,              'ablerc/dsl'
  autoload :Context,          'ablerc/context'
  autoload :Configuration,    'ablerc/configuration'
  autoload :StubGenerator,    'ablerc/stub_generator'
  autoload :Errors,           'ablerc/errors'


  ABLE_RC_FILE      =   'able.rc'


  mattr_accessor :scheme
  self.scheme = []


  mattr_accessor :options
  self.options = []


  mattr_accessor :rc_file_name
  self.rc_file_name = ''


  mattr_accessor :dsl
  self.dsl = Ablerc::DSL.new


  mattr_accessor :contexts
  self.contexts = Ablerc::Context


  mattr_accessor :stub_options
  self.stub_options = {}


  class << self


    # Iniatializes Ablerc with values from DSL
    def setup(&block)
      Ablerc.dsl.instance_eval(&block)
      scheme.each { |c| dsl.context(c, Ablerc::Context::DEFAULTS[c]) unless contexts.exists? c}
    end


    # Exposes option values from parsed rc files.
    # Aliased as <tt>#config</tt>
    def configuration
      Ablerc::Configuration.instance
    end


    alias :config :configuration


    # Prepares a stub rcfile with defined options
    def stub
      Ablerc::StubGenerator.new({:options => options}.merge(stub_options))
    end


    # Loads the rc files in the order and locations specified by scheme
    def load_scheme
      raise RcFileMissing, "You must provide a value to rc_file_name" if rc_file_name.blank?
      self.scheme.each do |scheme|
        configuration.load File.expand_path(File.join( contexts[scheme].path, rc_file_name))
      end
    end

    def load!(path)
      load_able_rc! File.expand_path( File.join( path, ABLE_RC_FILE))
    end

    private


    def gem_root
      File.expand_path '../..', __FILE__
    end


    def load_able_rc!(path)
      instance_eval(File.read( path ))
      load_scheme
      return configuration
    end
  end

  # Immediatly load options and rc file configurations
  #load_able_rc!

end
