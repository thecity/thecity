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

      # @return [String]
      def bearer_token
        if instance_variable_defined?(:@bearer_token)
          @bearer_token
        else
          ENV['BEARER_TOKEN']
        end
      end

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

      # @return [Boolean]
      def bearer_token?
        return true
        !!bearer_token
      end

      # @return [Boolean]
      def credentials?
        super || bearer_token?
      end

    private

      # Returns a proc that can be used to setup the Faraday::Request headers
      #
      # @param method [Symbol]
      # @param path [String]
      # @param params [Hash]
      # @return [Proc]
      def request_setup(method, path, params, signature_params)
        puts ""
        puts "***************************"
        puts "***************************"
        puts "    params: #{params.inspect}"
        Proc.new do |request|
          if params.delete(:bearer_token_request)
            puts "bearer"
            request.headers[:authorization] = bearer_token_credentials_auth_header
            request.headers[:content_type] = 'application/x-www-form-urlencoded; charset=UTF-8'
           # request.headers[:accept] = '*/*' # It is important we set this, otherwise we get an error.
          elsif params.delete(:app_auth) #|| !user_token?
            puts "app_auth"
            @bearer_token = token unless bearer_token?
            request.headers[:authorization] = bearer_auth_header
          else
            puts "else"
            request.headers[:authorization] = oauth_auth_header(method, ENDPOINT + path, signature_params).to_s
          end
        end
      end

      def request(method, path, params={}, signature_params=params)
        request_setup = request_setup(method, path, params, signature_params)
        connection.send(method.to_sym, path, params, &request_setup).env
      rescue Faraday::Error::ClientError, JSON::ParserError
        raise TheCity::Error
      end

      # Returns a Faraday::Connection object
      #
      # @return [Faraday::Connection]
      def connection
        @connection ||= Faraday.new(ENDPOINT, connection_options)
      end

      # Generates authentication header for token request
      #
      # @return [String]
      def bearer_token_credentials_auth_header
        basic_auth_token = strict_encode64("#{@app_id}:#{@app_secret}")
        "Basic #{basic_auth_token}"
      end

      def bearer_auth_header
        #"Bearer #{bearer_token.access_token}"
        "Bearer #{access_token}"
      end

    private

      # Base64.strict_encode64 is not available on Ruby 1.8.7
      def strict_encode64(str)
        Base64.encode64(str).gsub("\n", "")
      end

    end
  end
end
