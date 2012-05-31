require 'faraday'
require 'yajl'

module Twitter
  module Response
    class Error < RuntimeError; end
    class ParseError < Error; end

    class ParseJson < Faraday::Response::Middleware
      def parse(body)
          case body
          when ''
            nil
          when 'true'
            true
          when 'false'
            false
          else
            begin
              Yajl.load(body)
            rescue => error
              raise(ParseError, "Unable to read '#{body.inspect}': #{error.inspect}")
            end
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
