require 'addressable/uri'
require 'json'
require 'time'
require 'httparty'

module Onionbot
  class Chinachu
    def initialize
      @config = Config.instance
    end

    def queues
      result = {}
      HTTParty.get(url, {headers: {'User-Agent': Package.user_agent}}).each do |queue|
        result[queue['id']] = queue
      end
      return result
    end

    def summary(queue)
      values = {}
      ['id', 'title', 'subTitle', 'episode', 'description', 'category'].each do |key|
        values[key] = queue[key] if queue[key].to_s != ''
      end
      values['channel'] = queue['channel']['name']
      ['start', 'end'].each do |key|
        values[key] = Time.at(queue[key] / 1000).to_s
      end
      return values
    end

    def url
      unless @url
        @url = Addressable::URI.parse(@config['/chinachu/url'])
        @url.path = '/api/recording.json'
      end
      return @url
    end
  end
end
