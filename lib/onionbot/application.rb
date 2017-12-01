require 'onionbot/chinachu'
require 'onionbot/slack'
require 'onionbot/data_file'
require 'syslog/logger'
require 'yaml'

module OnionBot
  class Application
    def execute
      sleep(sleep_seconds)

      result = chinachu.queues
      result.each do |key, queue|
        unless data_file.load[key]
          message = create_message(queue, '録画開始')
          slack.say(message)
          logger.info(message.to_json)
        end
      end

      data_file.load.each do |key, queue|
        unless result[key]
          message = create_message(queue, '録画終了')
          slack.say(message)
          logger.info(message.to_json)
        end
      end

      data_file.save(result)
    rescue => e
      puts "#{e.class} #{e.message}"
      logger.error({class: e.class, message: e.message}.to_json)
      exit 1
    end

    private
    def config
      unless @config
        @config = {}
        Dir.glob(File.join(ROOT_DIR, 'config', '*.yaml')).each do |f|
          @config[File.basename(f, '.yaml')] = YAML.load_file(f)
        end
        unless @config['local']
          raise "local.yamlが見つかりません。"
        end
      end
      return @config
    end

    def chinachu
      unless @chinachu
        @chinachu = OnionBot::Chinachu.new(config['local']['chinachu'])
      end
      return @chinachu
    end

    def slack
      unless @slack
        @slack = OnionBot::Slack.new(config['local']['slack'])
      end
      return @slack
    end

    def data_file
      unless @data_file
        @data_file = OnionBot::DataFile.new
      end
      return @data_file
    end

    def logger
      unless @logger
        @logger = Syslog::Logger.new(config['application']['name'])
      end
      return @logger
    end

    def create_message (queue, message_string)
      message = chinachu.summary(queue)
      message['message'] = message_string
      return message
    end

    def sleep_seconds
      return (config['local']['sleep'] || config['application']['sleep'])
    end
  end
end
