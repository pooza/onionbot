require 'onionbot/config'
require 'onionbot/chinachu'
require 'onionbot/slack'
require 'onionbot/data_file'
require 'syslog/logger'

module OnionBot
  class Application
    def initialize
      @config = Config.new
      @logger = Syslog::Logger.new(@config['application']['name'])
      @chinachu = Chinachu.new(@config['local']['chinachu'])
      @slack = Slack.new(@config['local']['slack'])
      @data_file = DataFile.new
    end

    def execute
      sleep(sleep_seconds)
      queues = @chinachu.queues

      @data_file.load.each do |key, queue|
        unless queues[key]
          message = create_message(queue, '録画終了')
          @slack.say(message)
          @logger.info(message.to_json)
        end
      end

      queues.each do |key, queue|
        unless @data_file.load[key]
          message = create_message(queue, '録画開始')
          @slack.say(message)
          @logger.info(message.to_json)
        end
      end

      @data_file.save(queues)
    rescue => e
      puts "#{e.class} #{e.message}"
      @logger.error({class: e.class, message: e.message}.to_json)
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
