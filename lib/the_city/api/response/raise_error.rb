require 'faraday'
require 'the_city/error/bad_gateway'
require 'the_city/error/bad_request'
require 'the_city/error/forbidden'
require 'the_city/error/gateway_timeout'
require 'the_city/error/internal_server_error'
require 'the_city/error/not_acceptable'
require 'the_city/error/not_found'
require 'the_city/error/service_unavailable'
require 'the_city/error/too_many_requests'
require 'the_city/error/unauthorized'
require 'the_city/error/unprocessable_entity'

module TheCity
  module API
    module Response
      class RaiseError < Faraday::Response::Middleware

        def on_complete(env)
          status_code = env[:status].to_i
          error_class = TheCity::Error.errors[status_code]
          raise error_class.from_response(env) if error_class
        end

      end
    end
  end
end
