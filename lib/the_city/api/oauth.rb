require 'the_city/api/utils'
require 'the_city/token'

module TheCity
  module API
    module OAuth
      include TheCity::API::Utils

      def authentication_url
        "https://authentication.onthecity.org/oauth/authorize?#{authentication_headers}"
      end

      def authentication_headers

      end

      def authentication_params
        "scope=user_basic&app_id="
      end

      def authorization_url(code)
      end

      # Allows a registered application to obtain an OAuth 2 Bearear Token, which can be used to make API requests
      # on an application's own behalf, without a user context.
      #
      # Only one bearer token may exist outstanding for an application, and repeated requests to this method
      # will yield the same already-existent token until it has been invalidated.
      #
      # @return [TheCity::Token] The Bearer Token. token_type should be 'bearer'.
      # @example Generate a Bearer Token
      #   client = TheCity::API::Client.new(:consumer_key => "abc", :consumer_secret => 'def')
      #   bearer_token = client.token
      def token
        object_from_response(TheCity::Token, :post, "/oauth2/token", :grant_type => "client_credentials", :bearer_token_request => true)
      end
      alias bearer_token token

      # Allows a registered application to revoke an issued OAuth 2 Bearer Token by presenting its client credentials.
      #
      # @param access_token [String, TheCity::Token] The bearer token to revoke.
      # @return [TheCity::Token] The invalidated token. token_type should be nil.
      def invalidate_token(access_token)
        access_token = access_token.access_token if access_token.is_a?(TheCity::Token)
        object_from_response(TheCity::Token, :post, "/oauth2/invalidate_token", :access_token => access_token)
      end

    end
  end
end
