module Onionbot
  class Application
    def initialize
      @config = Config.instance
      @logger = Logger.new
      @chinachu = Chinachu.new
      @data_file = DataFile.new
    end

    def execute
      @logger.info({message: 'start', version: Package.version})
      sleep(sleep_seconds)
      @data_file.load.each do |k, q|
        Slack.broadcast(create_message(q, '録画終了')) unless @chinachu.queues[k]
      end
      @chinachu.queues.each do |k, q|
        Slack.broadcast(create_message(q, '録画開始')) unless @data_file.load[k]
      end
      @data_file.save(@chinachu.queues)
      @logger.info({message: 'end', version: Package.version})
    rescue => e
      message = create_error_message(e)
      @logger.error(message)
      Slack.broadcast(message)
      exit 1
    end

    private

    def create_message(queue, message_string)
      message = @chinachu.summary(queue)
      message['message'] = message_string
      return message
    end

    def create_error_message(exception)
      return {
        class: exception.class,
        message: exception.message,
        backtrace: exception.backtrace[0..5],
      }
    end

    def sleep_seconds
      return (@config['local']['sleep'] || @config['application']['sleep'])
    end
  end
end
