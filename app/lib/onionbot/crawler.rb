module Onionbot
  class Crawler
    def initialize
      @config = Config.instance
      @chinachu = Chinachu.new
      @data_file = DataFile.new
    end

    def exec
      messages = []
      sleep(@config['/sleep'])
      @data_file.load.each do |k, q|
        messages.push(create_message(q, '録画終了'))
      end
      @chinachu.queues.each do |k, q|
        messages.push(create_message(q, '録画開始'))
      end
      @data_file.save(@chinachu.queues)
      puts messages.map {|m| YAML.dump(m)}.join("=====\n")
    end

    private

    def create_message(queue, message_string)
      message = @chinachu.summary(queue)
      message['message'] = message_string
      return message
    end
  end
end
