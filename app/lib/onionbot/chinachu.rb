require 'time'

module Onionbot
  class Chinachu
    def initialize
      @config = Config.instance
      @http = HTTP.new
    end

    def queues
      result = {}
      @http.get(url).each do |queue|
        result[queue['id']] = queue
      end
      return result
    end

    def summary(queue)
      values = {}
      ['title', 'subTitle', 'episode', 'description', 'category'].each do |key|
        values[key] = queue[key] if queue[key].present?
      end
      values['channel'] = queue['channel']['name']
      ['start', 'end'].each do |key|
        values[key] = Time.at(queue[key] / 1000).to_s
      end
      return values
    end

    def url
      unless @url
        @url = Ginseng::URI.parse(@config['/chinachu/url'])
        @url.path = '/api/recording.json'
      end
      return @url
    end
  end
end
