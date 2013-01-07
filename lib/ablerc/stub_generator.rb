module Ablerc
  class StubGenerator

    attr_accessor :options, :path, :header, :footer


    def initialize(options)
      self.header = options.delete :header
      self.footer = options.delete :footer
      self.options = options.delete :options
    end


    def generate(context = nil)
      begin
        context ||= Ablerc.contexts.names.last.to_sym
        path = File.expand_path(Ablerc.contexts.send(context.to_sym).path)
      rescue
        raise "Context does not exist"
      end

      puts "Generating Stub for #{context} in #{path + '/' + Ablerc.rc_file_name}".color :green

      begin
        File.open(path + '/' + Ablerc.rc_file_name, 'w') do |rc_file|
          rc_file << header.to_s unless header.nil?
          self.options.each do |option|
            rc_file << option.to_stub
          end
          rc_file << footer.to_s unless footer.nil?
        end
      rescue e
        puts "Error".color :red
        puts e
      end

      true
    end

    def write_description(description)
    end

  end
end
