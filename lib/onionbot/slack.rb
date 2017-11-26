require 'addressable/uri'
require 'httparty'
require 'json'

module OnionBot
  class Slack
    def initialize (config)
      @config = config
    end

    def hook_url
      unless @url
        @url = Addressable::URI.parse(@config['hook']['url'])
      end
      return @url
    end

    def say (message)
      HTTParty.post(hook_url, {
        body: {text: JSON.pretty_generate(message)}.to_json,
        headers: {'Content-Type' => 'application/json'},
        ssl_ca_file: File.join(ROOT_DIR, 'cert/cacert.pem'),
      })
    end
  end
end
