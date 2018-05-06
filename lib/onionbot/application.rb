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
      queues = @chinachu.queues

      @data_file.load.each do |key, queue|
        unless queues[key]
          message = create_message(queue, '録画終了')
          @slack.say(message)
          @logger.info(message)
        end
      end

      queues.each do |key, queue|
        unless @data_file.load[key]
          message = create_message(queue, '録画開始')
          @slack.say(message)
          @logger.info(message)
        end
      end

      @data_file.save(queues)
      @logger.info({message: 'end'})
    rescue => e
      message = {class: e.class, message: e.message}
      @slack.say(message)
      @logger.error(message)
      exit 1
    end

    private
    def create_message (queue, message_string)
      message = @chinachu.summary(queue)
      message['message'] = message_string
      return message
    end

    def sleep_seconds
      return (@config['local']['sleep'] || @config['application']['sleep'])
    end
  end
end
