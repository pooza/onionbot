require 'onionbot/config'
require 'onionbot/chinachu'
require 'onionbot/slack'
require 'onionbot/data_file'
require 'onionbot/logger'

module OnionBot
  class Application
    def initialize
      @config = Config.instance
      @logger = Logger.new
      @chinachu = Chinachu.new
      @data_file = DataFile.new
    end

    def execute
      @logger.info({message: 'start'})
      sleep(sleep_seconds)
      @data_file.load.each do |k, q|
        hooks.map{ |h| h.say(create_message(q, '録画終了'))} unless @chinachu.queues[k]
      end
      @chinachu.queues.each do |k, q|
        hooks.map{ |h| h.say(create_message(q, '録画開始'))} unless @data_file.load[k]
      end
      @data_file.save(@chinachu.queues)
      @logger.info({message: 'end'})
    rescue => e
      hooks.map{ |h| h.say({class: e.class, message: e.message})}
      exit 1
    end

    private

    def hooks
      return enum_for(__method__) unless block_given?
      @config['local']['slack']['hooks'].each do |url|
        yield Slack.new(url)
      end
    end

    def create_message(queue, message_string)
      message = @chinachu.summary(queue)
      message['message'] = message_string
      return message
    end

    def sleep_seconds
      return (@config['local']['sleep'] || @config['application']['sleep'])
    end
  end
end
