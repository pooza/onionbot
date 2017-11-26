require 'onionbot/chinachu'
require 'onionbot/slack'
require 'syslog/logger'
require 'json'
require 'yaml'

module OnionBot
  class Application
    def execute
      sleep(sleep_seconds)

      result = chinachu.queues
      result.each do |key, queue|
        unless prev_result[key]
          message = chinachu.summary(queue)
          message['message'] = '録画開始'
          slack.say(message)
          logger.info(message.to_json)
        end
      end

      prev_result.each do |key, queue|
        unless result[key]
          message = chinachu.summary(queue)
          message['message'] = '録画終了'
          slack.say(message)
          logger.info(message.to_json)
        end
      end

      save(result)
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

    def logger
      unless @logger
        @logger = Syslog::Logger.new(config['application']['name'])
      end
      return @logger
    end

    def sleep_seconds
      return (config['local']['sleep'] || config['application']['sleep'])
    end

    def result_path
      return File.join(ROOT_DIR, 'tmp/recording.json')
    end

    def prev_result
      unless @prev
        @prev = {}
        @prev = JSON.parse(File.read(result_path)) if File.exist?(result_path)
      end
      return @prev
    end

    def save (result)
      File.write(result_path, JSON.pretty_generate(result))
    end
  end
end
