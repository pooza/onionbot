require 'onionbot/config'

module OnionBot
  module Package
    def self.name
      return File.basename(ROOT_DIR)
    end

    def self.version
      return Config.instance['application']['package']['version']
    end

    def self.url
      return Config.instance['application']['package']['url']
    end

    def self.full_name
      return "#{self.name} #{self.version}"
    end
  end
end
