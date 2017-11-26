require 'addressable/uri'
require 'open-uri'
require 'digest/sha1'
require 'time'

module OnionBot
  class Chinachu
    def initialize (config)
      @config = config
    end

    def queues
      result = {}
      JSON.parse(open(url.to_s).read).each do |queue|
        result[Digest::SHA1.hexdigest(queue.to_s)] = queue
      end
      return result
    end

    def summary (queue)
      return {
        title: queue['title'],
        subTitle: queue['subTitle'],
        episode: queue['episode'],
        description: queue['descriptiion'],
        start: Time.at(queue['start'] / 1000).to_s,
        end: Time.at(queue['end'] / 1000).to_s,
        cateogry: queue['category'],
        channel: queue['channel']['name'],
      }
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
