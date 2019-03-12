module Onionbot
  module Package
    def environment_class
      return 'Onionbot::Environment'
    end

    def package_class
      return 'Onionbot::Package'
    end

    def config_class
      return 'Onionbot::Config'
    end

    def logger_class
      return 'Onionbot::Logger'
    end

    def http_class
      return 'Onionbot::HTTP'
    end

    def self.name
      return 'onionbot'
    end

    def self.version
      return Config.instance['/package/version']
    end

    def self.url
      return Config.instance['/package/url']
    end

    def self.full_name
      return "#{name} #{version}"
    end

    def self.user_agent
      return "#{name}/#{version} (#{url})"
    end
  end
end
