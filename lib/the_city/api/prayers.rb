require 'the_city/arguments'
require 'the_city/api/utils'
require 'the_city/prayer'

module TheCity
  module API
    module prayers
      include TheCity::API::Utils
  
      # Posts a prayer to The City
      #
      # @see https://api.onthecity.org/docs
      #
      # @req_scope group_content
      # @return [TheCity::Prayer]
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :group_id The id of the group you will be posting to.
      # @option options [String] :title The title of the prayer.
      # @option options [String] :body The body text of the prayer.
      def post_prayer(options)
        raise(Error::ArgumentError, "Must supply a options[:group_id] for the prayers's originating group") unless options[:group_id]
        raise(Error::ArgumentError, "Title (options[:title]) required") unless options[:title]
        raise(Error::ArgumentError, "Body (options[:body]) required") unless options[:body]
        gid = options[:group_id] || 0
        object_from_response(TheCity::Prayer, :post, "/groups/#{gid}/prayers/", options, {:client => self})
      end

      # Returns a prayer by id
      #
      # @see https://api.onthecity.org/docs
      #
      # @req_scope group_content
      # @return [TheCity::Prayer]
      # @raise [TheCity::Error::NotFound] Error raised when the prayer cannot be found.
      # @overload prayer(id)
      #   @param id [Integer] The id of the prayer.
      # @overload prayer(id, options={})
      #   @param id [Integer] The id of the prayer.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean] :force_download Forces the request to hit the server and flush the cached response
      def prayer(*args)
        @prayers ||= {}
        arguments = TheCity::Arguments.new(args)
        pid = args.shift
        @prayers[pid] = nil if arguments.options.delete(:force_download)
        @prayers[pid] ||= object_from_response(TheCity::Prayer, :get, "/prayers/#{pid}", arguments.options, {:client => self})
      end

    end
  end
end
