require 'onionbot/config'

module OnionBot
  module Package
    def self.name
      return 'onionbot'
    end

    def self.version
      return Config.instance['application']['package']['version']
    end

    def self.url
      return Config.instance['application']['package']['url']
    end

    def self.full_name
      return "#{name} #{version}"
    end
  end
end
