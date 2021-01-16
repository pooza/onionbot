module Onionbot
  class DataFile
    def load
      unless @data
        @data = JSON.parse(File.read(path)) if File.exist?(path)
        @data ||= {}
      end
      return @data
    end

    def save(result)
      @data = nil
      File.write(path, result.to_json)
    end

    def path
      return File.join(Environment.dir, 'tmp/recording.json')
    end
  end
end
