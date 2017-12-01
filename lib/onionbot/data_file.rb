require 'json'

module OnionBot
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

    def save (result)
      @data = nil
      File.write(path, JSON.pretty_generate(result))
    end

    private
    def path
      unless @path
        @path = File.join(ROOT_DIR, 'tmp/recording.json')
      end
      return @path
    end
  end
end