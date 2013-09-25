require 'simple_oauth'
require 'the_city/version'
require 'uri'

module TheCity
  class Client
    attr_writer :access_token, :app_id, :app_secret, :subdomain, :version
    alias oauth_token= access_token=

    # Initializes a new Client object
    #
    # @param options [Hash]
    # @return [TheCity::API::Client]
    def initialize(options={})
      for key, value in options
        send(:"#{key}=", value)
      end
      yield self if block_given?
    end

    # @return [String]
    def subdomain
      if instance_variable_defined?(:@subdomain)
        @subdomain
      else
        ENV['THECITY_SUBDOMAIN']
      end
    end

    # @return [String]
    def app_id
      if instance_variable_defined?(:@app_id)
        @app_id
      else
        ENV['THECITY_APP_ID']
      end
    end

    # @return [String]
    def app_secret
      if instance_variable_defined?(:@app_secret)
        @app_secret
      else
        ENV['THECITY_APP_SECRET']
      end
    end

    # @return [String]
    def access_token
      if instance_variable_defined?(:@access_token)
        @access_token
      else
        ENV['THECITY_ACCESS_TOKEN']
      end
    end
    alias oauth_token access_token

    # @return [String]
    def version
      if instance_variable_defined?(:@version)
        @api_version || "1"
      elsif ENV['THECITY_API_VERSION']
        ENV['THECITY_API_VERSION']
      else
        "1"
      end
    end
    alias api_version version

    # @return [Hash]
    def credentials
      {
        :app_id     => app_id,
        :app_secret => app_secret,
        :token      => access_token,
      }
    end

    # @return [Boolean]
    def credentials?
      credentials.values.all?
    end

  private

    # Ensures that all credentials set during configuration are of a
    # valid type. Valid types are String and Symbol.
    def validate_credentials!
      for credential, value in credentials
        raise(Error::ConfigurationError, "Invalid #{credential} specified: #{value.inspect} must be a string or symbol.") unless value.is_a?(String) || value.is_a?(Symbol)
      end
    end

    def oauth_auth_header(method, uri, params={})
      uri = URI.parse(uri)
      SimpleOAuth::Header.new(method, uri, params, credentials)
    end

  end
end
