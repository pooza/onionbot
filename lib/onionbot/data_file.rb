require 'json'

module Onionbot
  class DataFile
    def load
      unless @data
        if File.exist?(path)
          @data = JSON.parse(File.read(path))
        else
          @data = {}
        end
      end
      return @data
    end

    def save(result)
      @data = nil
      File.write(path, JSON.pretty_generate(result))
    end

    def path
      return File.join(ROOT_DIR, 'tmp/recording.json')
    end
  end
end
