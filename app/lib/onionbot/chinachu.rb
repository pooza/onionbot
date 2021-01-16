require 'time'

module Onionbot
  class Chinachu
    def initialize
      @config = Config.instance
      @http = Ginseng::HTTP.new
      @http.base_uri = @config['/chinachu/url']
    end

    def queues
      return @http.get('/api/recording.json').map {|v| [v['id'], v]}.to_h
    rescue
      return {}
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
  end
end
