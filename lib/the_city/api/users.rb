require 'the_city/api/utils'

module TheCity
  module API
    module Users
      include TheCity::API::Utils

      # @see https://api.onthecity.org/docs
      #
      # @return [TheCity::User] The requested user.
      # @raise [TheCity::Error::NotFound] Error raised when the user cannot be found.
      # @req_scope user_trusted
      # @overload user(id)
      #   @param id [Integer] The id of the user.
      # @overload user(id, options={})
      #   @param id [Integer] The id of the user.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean] :force_download Forces the request to hit the server and flush the cached response
      def user(*args)
        @users ||= {}
        arguments = TheCity::Arguments.new(args)
        uid = args.shift
        @users[uid] = nil if arguments.options.delete(:force_download)
        @users[uid] ||= TheCity::User.from_response_with_options(send(:get, "/users/#{uid}", arguments.options), {:client => self})
      end

      # Returns the user associated with the current access token
      #
      # @see https://api.onthecity.org/docs
      #
      # @req_scope user_basic
      # @opt_scope user_extended
      # @return [TheCity::User] The authenticated user.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean] :force_download Forces the request to hit the server and flush the cached response
      def me(options={})
        @me = nil if options.delete(:force_download)
        @me ||= TheCity::User.from_response_with_options(send(:get, "/me", options), {:current_user => true, :client => self})
      end
      alias current_user me

      # Returns the permissions for the current user
      #
      # @see https://api.onthecity.org/docs
      #
      # @req_scope user_permissions
      # @opt_scope group_content
      # @return [TheCity::Permissions] The permission object for the current user.
      # @overload permissions(options={})
      #   @param options [Hash] A customizable set of options.
      def permissions(*args)
        arguments = TheCity::Arguments.new(args)
        object_from_response(TheCity::Permissions, :get, "/me/permissions", arguments.options)
        #get("/me/permissions")[:body]
      end

      # Returns true if the specified user exists
      #
      # @req_scope user_trusted
      # @return [Boolean] true if the user exists, otherwise false.
      # @param user [Integer, String, TheCity::User] A City user id, or object.
      def user?(user)
        user_id = case user
        when ::Integer
          user
        when ::String
          user.to_i
        when TheCity::User
          user.id
        end
        get("/users/#{user_id}")
        true
      rescue TheCity::Error::NotFound
        false
      end

    end
  end
end
