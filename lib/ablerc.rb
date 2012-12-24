require "ablerc/version"
require "active_support/core_ext"
require "rainbow"

module Ablerc
  autoload :Option,       'ablerc/option'
  autoload :DSL,          'ablerc/dsl'
  autoload :Context,      'ablerc/context'
  autoload :Configuration ,'ablerc/configuration'

  ABLE_RC_FILE      =   'able.rc'
  DEFUALT_CONTEXTS  =   {global: {path: '/etc/'},
                         user:   {path: '~/'},
                         local:  {path: './'}}

  class RcFileMissing < Exception; end
  class AbleRCConfigMissing < Exception; end

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


  class << self 
    
    # Iniatializes Ablerc with values from DSL
    def setup(&block)
      Ablerc.dsl.instance_eval(&block)
      scheme.each { |c| dsl.context(c, DEFUALT_CONTEXTS[c]) unless contexts.exists? c}
    end

    # Exposes option values from parsed rc files.
    # Aliased as <tt>#config</tt>
    def configuration
      Ablerc::Configuration.instance
    end

    alias :config :configuration

    def load_scheme
      raise RcFileMissing, "You must provide a value to rc_file_name" if rc_file_name.blank?
      self.scheme.each do |scheme|
        configuration.load File.expand_path(File.join( contexts[scheme].path, rc_file_name))
      end
    end

    private
    def load_able_rc!
      instance_eval(File.read( File.expand_path( File.join('.', ABLE_RC_FILE))))
      load_scheme
      return configuration
    end
  end

  load_able_rc!
end
