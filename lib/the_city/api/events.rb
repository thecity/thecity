require 'the_city/arguments'
require 'the_city/api/utils'
require 'the_city/event'

module TheCity
  module API
    module Events
      include TheCity::API::Utils
  
      # Posts an Event to The City
      #
      # @see https://api.onthecity.org/docs
      #
      # @req_scope group_content
      # @return [TheCity::Event]
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :group_id The id of the group you will be posting to.
      # @option options [String] :title The title of the event.
      # @option options [String] :body The body text of the event.
      # @option options [Time] :starting_at The body text of the event.
      # @option options [Time] :ending_at The body text of the event.
      def post_event(options)
        raise(Error::ArgumentError, "Must supply a options[:group_id] for the events's originating group") unless options[:group_id]
        raise(Error::ArgumentError, "Title (options[:title]) required") unless options[:title]
        raise(Error::ArgumentError, "Body (options[:body]) required") unless options[:body]
        raise(Error::ArgumentError, "Starting At (options[:starting_at]) required") unless options[:starting_at]
        raise(Error::ArgumentError, "Ending At (options[:ending_at]) required") unless options[:ending_at]
        gid = options[:group_id] || 0
        object_from_response(TheCity::Event, :post, "/groups/#{gid}/events/", options, {:client => self})
      end

      # Returns an Event by id
      #
      # @see https://api.onthecity.org/docs
      #
      # @req_scope group_content
      # @return [TheCity::Event]
      # @raise [TheCity::Error::NotFound] Error raised when the event cannot be found.
      # @overload event(id)
      #   @param id [Integer] The id of the event.
      # @overload event(id, options={})
      #   @param id [Integer] The id of the event.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean] :force_download Forces the request to hit the server and flush the cached response
      def event(*args)
        @events ||= {}
        arguments = TheCity::Arguments.new(args)
        eid = args.shift
        @events[eid] = nil if arguments.options.delete(:force_download)
        @events[eid] ||= object_from_response(TheCity::Event, :get, "/events/#{eid}", arguments.options, {:client => self})
      end

    end
  end
end
