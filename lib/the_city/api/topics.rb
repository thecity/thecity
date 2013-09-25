require 'the_city/arguments'
require 'the_city/api/utils'
require 'the_city/topic'

module TheCity
  module API
    module Topics
      include TheCity::API::Utils
  
      # Posts a topic to The City
      #
      # @see https://api.onthecity.org/docs
      #
      # @req_scope group_content
      # @return [TheCity::Topic]
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :group_id The id of the group you will be posting to.
      # @option options [String] :title The title of the topic.
      # @option options [String] :body The body text of the topic.
      def post_topic(options)
        raise(Error::ArgumentError, "Must supply a options[:group_id] for the topic's originating group") unless options[:group_id]
        raise(Error::ArgumentError, "Title (options[:title]) required") unless options[:title]
        raise(Error::ArgumentError, "Body (options[:body]) required") unless options[:body]
        gid = options[:group_id] || 0
        object_from_response(TheCity::Topic, :post, "/groups/#{gid}/topics/", options, {:client => self})
      end

      # Returns a topic by id
      #
      # @see https://api.onthecity.org/docs
      #
      # @req_scope group_content
      # @return [TheCity::Topic]
      # @raise [TheCity::Error::NotFound] Error raised when the topic cannot be found.
      # @overload topic(id)
      #   @param id [Integer] The id of the topic.
      # @overload topic(id, options={})
      #   @param id [Integer] The id of the topic.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean] :force_download Forces the request to hit the server and flush the cached response
      def topic(*args)
        @topics ||= {}
        arguments = TheCity::Arguments.new(args)
        tid = args.shift
        @topics[tid] = nil if arguments.options.delete(:force_download)
        @topics[tid] ||= object_from_response(TheCity::Topic, :get, "/topics/#{tid}", arguments.options, {:client => self})
      end

    end
  end
end
