module Lograge
  module Formatters
    class Logstash
      def call(data, type = 'controller')
        load_dependencies
        event = LogStash::Event.new(data)

        event.delete(:headers) if event[:headers].class != Hash

        event['message'] = "[#{data[:status]}] #{data[:method]} #{data[:path]} (#{data[:controller]}##{data[:action]})" if type == 'controller'
        event['message'] = data[:message] if type == 'job'

        event.to_json
      end

      def load_dependencies
        require 'logstash-event'
      rescue LoadError
        puts 'You need to install the logstash-event gem to use the logstash output.'
        raise
      end
    end
  end
end
