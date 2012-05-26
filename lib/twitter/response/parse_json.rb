require 'faraday'

module Twitter
  module Response
    class ParseJson < Faraday::Response::Middleware
      dependency {
        require 'json' unless defined?(JSON)
      }

      def parse(body)
          case body
          when ''
            nil
          when 'true'
            true
          when 'false'
            false
          else
            JSON.load(body)
          end
      end

      def on_complete(env)
        if respond_to? :parse
          env[:body] = parse(env[:body]) unless env[:request][:raw] or [204,304].index env[:status]
        end
      end
    end
  end
end
