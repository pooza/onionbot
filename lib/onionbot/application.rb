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
      sleep(@config['/sleep'])
      @data_file.load.each do |k, q|
        Slack.broadcast(create_message(q, '録画終了')) unless @chinachu.queues[k]
      end
      @chinachu.queues.each do |k, q|
        Slack.broadcast(create_message(q, '録画開始')) unless @data_file.load[k]
      end
      @data_file.save(@chinachu.queues)
      @logger.info({message: 'end', version: Package.version})
    rescue => e
      e = Ginseng::Error.create(e)
      Slack.broadcast(e.to_h)
      @logger.error(e.to_h)
      exit 1
    end

    private

    def create_message(queue, message_string)
      message = @chinachu.summary(queue)
      message['message'] = message_string
      return message
    end
  end
end
