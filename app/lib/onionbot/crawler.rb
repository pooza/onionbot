module Onionbot
  class Crawler
    def initialize
      @config = Config.instance
      @logger = Logger.new
      @chinachu = Chinachu.new
      @data_file = DataFile.new
    end

    def crawl
      @logger.info(message: 'start', version: Package.version)
      sleep(@config['/sleep'])
      @data_file.load.each do |k, q|
        Slack.broadcast(create_message(q, '録画終了')) unless @chinachu.queues[k]
        @logger.info(q: q, message: 'end')
      end
      @chinachu.queues.each do |k, q|
        Slack.broadcast(create_message(q, '録画開始')) unless @data_file.load[k]
        @logger.info(q: q, message: 'start')
      end
      @data_file.save(@chinachu.queues)
      @logger.info(message: 'end', version: Package.version)
    rescue => e
      e = Ginseng::Error.create(e)
      e.package = Package.full_name
      Slack.broadcast(e)
      @logger.error(e)
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
