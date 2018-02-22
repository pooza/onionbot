require 'onionbot/config'
require 'onionbot/chinachu'
require 'onionbot/slack'
require 'onionbot/data_file'
require 'syslog/logger'

module OnionBot
  class Application
    def initialize
      @config = Config.instance
      @chinachu = Chinachu.new
      @slack = Slack.new
      @data_file = DataFile.new
    end

    def execute
      sleep(sleep_seconds)
      queues = @chinachu.queues

      @data_file.load.each do |key, queue|
        unless queues[key]
          message = create_message(queue, '録画終了')
          @slack.say(message)
          Application.logger.info(message.to_json)
        end
      end

      queues.each do |key, queue|
        unless @data_file.load[key]
          message = create_message(queue, '録画開始')
          @slack.say(message)
          Application.logger.info(message.to_json)
        end
      end

      @data_file.save(queues)
    rescue => e
      puts "#{e.class} #{e.message}"
      Application.logger.error({
        class: e.class,
        message: e.message,
        version: Application.version,
      }.to_json)
      exit 1
    end

    def self.name
      return Config.instance['application']['name']
    end

    def self.version
      return Config.instance['application']['version']
    end

    def self.url
      return Config.instance['application']['url']
    end

    def self.full_name
      return "#{Application.name} #{Application.version}"
    end

    def self.logger
      return Syslog::Logger.new(Application.name)
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
