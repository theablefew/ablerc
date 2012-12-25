module Ablerc
  class StubGenerator

    attr_accessor :options, :path, :header, :footer


    def initialize(path, options)
      self.header = options.delete :header
      self.footer = options.delete :footer
      self.options = options.delete :options
      self.path = File.expand_path(path)
    end


    def generate
      File.open(path, 'w') do |rc_file|
        rc_file << header.to_s unless header.nil?
        self.options.each do |option|
          rc_file << option.to_stub
        end
        rc_file << footer.to_s unless footer.nil?
      end
    end

    def write_description(description)
    end

  end
end
