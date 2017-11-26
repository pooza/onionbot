require 'onionbot/chinachu'
require 'onionbot/slack'
require 'json'
require 'yaml'

module OnionBot
  class Application
    def execute
      result = chinachu.queues
      result.each do |key, queue|
        unless prev_result[key]
          message = chinachu.summary(queue)
          message['message'] = '録画開始'
          slack.say(message)
        end
      end

      prev_result.each do |key, queue|
        unless result[key]
          message = chinachu.summary(queue)
          message['message'] = '録画終了'
          slack.say(message)
        end
      end

      save(result)
    rescue => e
      puts "#{e.class} #{e.message}"
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
