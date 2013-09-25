require 'the_city/arguments'
require 'the_city/api/utils'

module TheCity
  module API
    module Groups
      include TheCity::API::Utils
  
      # Returns all the groups that the current user has an active role in
      #
      # @req_scope group_contont or user_groups
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean] :force_download Forces the request to hit the server and flush the cached response
      # @return [Array<TheCity::Group>]
      def my_groups(options={})
        @my_groups = nil if options.delete(:force_download)
        @my_groups ||= objects_from_response(TheCity::Group, :get, "/me/groups", options)
      end

      # Returns a group by id
      #
      # @req_scope group_trusted
      # @return [TheCity::Group]
      # @raise [TheCity::Error::NotFound] Error raised when the group cannot be found.
      # @overload group(id)
      #   @param id [Integer] The id of the group.
      # @overload group(id, options={})
      #   @param id [Integer] The id of the group.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean] :force_download Forces the request to hit the server and flush the cached response
      def group(*args)
        @groups ||= {}
        arguments = TheCity::Arguments.new(args)
        gid = args.shift
        @groups[tid] = nil if arguments.options.delete(:force_download)
        @groups[tid] ||= object_from_response(TheCity::Group, :get, "/groups/#{gid}", arguments.options)
      end

    end
  end
end
