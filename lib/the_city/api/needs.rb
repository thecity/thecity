require 'the_city/arguments'
require 'the_city/api/utils'
require 'the_city/need'

module TheCity
  module API
    module needs
      include TheCity::API::Utils
  
      # Posts a need to The City
      #
      # @see https://api.onthecity.org/docs
      #
      # @req_scope group_content
      # @return [TheCity::Need]
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :group_id The id of the group you will be posting to.
      # @option options [String] :title The title of the need.
      # @option options [String] :body The body text of the need.
      def post_need(options)
        raise(Error::ArgumentError, "Must supply a options[:group_id] for the needs's originating group") unless options[:group_id]
        raise(Error::ArgumentError, "Title (options[:title]) required") unless options[:title]
        raise(Error::ArgumentError, "Body (options[:body]) required") unless options[:body]
        gid = options[:group_id] || 0
        object_from_response(TheCity::Need, :post, "/groups/#{gid}/needs/", options, {:client => self})
      end

      # Returns a need by id
      #
      # @see https://api.onthecity.org/docs
      #
      # @req_scope group_content
      # @return [TheCity::Need]
      # @raise [TheCity::Error::NotFound] Error raised when the need cannot be found.
      # @overload need(id)
      #   @param id [Integer] The id of the need.
      # @overload need(id, options={})
      #   @param id [Integer] The id of the need.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean] :force_download Forces the request to hit the server and flush the cached response
      def need(*args)
        @needs ||= {}
        arguments = TheCity::Arguments.new(args)
        nid = args.shift
        @needs[nid] = nil if arguments.options.delete(:force_download)
        @needs[nid] ||= object_from_response(TheCity::Need, :get, "/needs/#{nid}", arguments.options, {:client => self})
      end

    end
  end
end
