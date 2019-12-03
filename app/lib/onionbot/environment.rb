module Onionbot
  class Environment < Ginseng::Environment
    def self.name
      return File.basename(dir)
    end

    def self.dir
      return Onionbot.dir
    end
  end
end
