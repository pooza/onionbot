require 'addressable/uri'
require 'open-uri'
require 'json'
require 'time'
require 'onionbot/config'

module OnionBot
  class Chinachu
    def initialize
      @config = Config.new['local']['chinachu']
    end

    def queues
      result = {}
      JSON.parse(open(url.to_s).read).each do |queue|
        result[queue['id']] = queue
      end
      return result
    end

    def summary (queue)
      values = {}
      ['id', 'title', 'subTitle', 'episode', 'description', 'category'].each do |key|
        values[key] = queue[key] if (queue[key].to_s != '')
      end
      values['channel'] = queue['channel']['name']
      ['start', 'end'].each do |key|
        values[key] = Time.at(queue[key] / 1000).to_s
      end
      return values
    end

    def url
      unless @url
        @url = Addressable::URI.parse(@config['url'])
        @url.path = '/api/recording.json'
      end
      return @url
    end
  end
end
