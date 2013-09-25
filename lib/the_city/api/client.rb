require 'base64'
require 'faraday'
require 'faraday/request/multipart'
require 'json'
require 'the_city/client'
require 'the_city/error'
require 'the_city/error/configuration_error'
require 'the_city/api/request/multipart_with_file'
require 'the_city/api/response/parse_json'
require 'the_city/api/response/raise_error'

#require 'the_city/api/oauth'
require 'the_city/api/users'
require 'the_city/api/accounts'
require 'the_city/api/groups'
require 'the_city/api/topics'
require 'the_city/api/events'
require 'the_city/api/prayers'
require 'the_city/api/needs'

module TheCity
  module API
    # Wrapper for the TheCity REST API
    #
    # @see http://api.onthecity.com/docs
    class Client < TheCity::Client
      #include TheCity::API::OAuth
      include TheCity::API::Users
      include TheCity::API::Accounts
      include TheCity::API::Groups
      include TheCity::API::Topics
      include TheCity::API::Events
      include TheCity::API::Prayers
      include TheCity::API::Needs

      attr_writer :bearer_token, :connection_options, :middleware

      ENDPOINT = ENV['THECITY_API_ENDPOINT'] || 'https://api.stagethecity.org'

      def connection_options
        {
          :builder => middleware,
          :headers => {
            :accept => "application/vnd.thecity.v#{version}+json",
            'X-CITY-SUBDOMAIN' => subdomain,
            'X-CITY-ACCESS-TOKEN' => access_token,
          },
          :request => {
            :open_timeout => 5,
            :timeout => 60,
          },
        }
      end

      # @note Faraday's middleware stack implementation is comparable to that of Rack middleware.  The order of middleware is important: the first middleware on the list wraps all others, while the last middleware is the innermost one.
      # @see https://github.com/technoweenie/faraday#advanced-middleware-usage
      # @see http://mislav.uniqpath.com/2011/07/faraday-advanced-http/
      # @return [Faraday::Builder]
      def middleware
        @middleware ||= Faraday::Builder.new do |builder|
          # Convert file uploads to Faraday::UploadIO objects
          builder.use TheCity::API::Request::MultipartWithFile
          # Checks for files in the payload
          builder.use Faraday::Request::Multipart
          # Convert request params to "www-form-urlencoded"
          builder.use Faraday::Request::UrlEncoded
          # Handle error responses
          builder.use TheCity::API::Response::RaiseError
          # Parse JSON response bodies
          builder.use TheCity::API::Response::ParseJson
          # Set Faraday's HTTP adapter
          builder.adapter Faraday.default_adapter
        end
      end

      # Perform an HTTP DELETE request
      def delete(path, params={})
        request(:delete, path, params)
      end

      # Perform an HTTP GET request
      def get(path, params={})
        request(:get, path, params)
      end

      # Perform an HTTP POST request
      def post(path, params={})
        signature_params = params.values.any?{|value| value.respond_to?(:to_io)} ? {} : params
        request(:post, path, params, signature_params)
      end

      # Perform an HTTP PUT request
      def put(path, params={})
        request(:put, path, params)
      end


    private

      # Returns a proc that can be used to setup the Faraday::Request headers
      #
      # @param method [Symbol]
      # @param path [String]
      # @param params [Hash]
      # @return [Proc]
      def request_setup(method, path, params, signature_params)
        Proc.new do |request|
          request.headers[:authorization] = bearer_auth_header
        end
      end

      def request(method, path, params={}, signature_params=params)
        validate_credentials!
        request_setup = request_setup(method, path, params, signature_params)
        connection.send(method.to_sym, ENDPOINT + path, params, &request_setup).env
      rescue Faraday::Error::ClientError, JSON::ParserError
        raise TheCity::Error
      end

      # Returns a Faraday::Connection object
      #
      # @return [Faraday::Connection]
      def connection
        @connection ||= Faraday.new(ENDPOINT, connection_options)
      end

      # Generates authentication header for api request
      #
      # @return [String]
      def bearer_auth_header
        "Bearer #{access_token}"
      end

    end
  end
end
