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
      @slack = Slack.new
      @data_file = DataFile.new
    end

    def execute
      @logger.info({message: 'start'})
      sleep(sleep_seconds)
      @data_file.load.each do |key, queue|
        next if queues[key]
        @slack.say(create_message(queue, '録画終了'))
      end
      queues.each do |key, queue|
        next if @data_file.load[key]
        @slack.say(create_message(queue, '録画開始'))
      end
      @data_file.save(queues)
      @logger.info({message: 'end'})
    rescue => e
      @slack.say({class: e.class, message: e.message})
      exit 1
    end

    private

    def queues
      return @chinachu.queues
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
