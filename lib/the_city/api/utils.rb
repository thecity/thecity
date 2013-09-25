require 'the_city/arguments'
require 'the_city/collection'
require 'the_city/user'
require 'the_city/group'
require 'the_city/account'
require 'uri'

module TheCity
  module API
    module Utils

    private

      # @param klass [Class]
      # @param request_method [Symbol]
      # @param path [String]
      # @param request_options [Hash]
      # @param options [Hash]
      # @return [Array]
      def objects_from_response(klass, request_method, path, request_options={}, options ={})
        response = send(request_method.to_sym, path, request_options)[:body]
        objects_from_array(klass, response, options)
      end

      # @param klass [Class]
      # @param array [Array]
      # @return [Array]
      def objects_from_array(klass, array, options={})
        array.map do |element|
          klass.new(element, options)
        end
      end

      # @param klass [Class]
      # @param request_method [Symbol]
      # @param path [String]
      # @param request_options [Hash]
      # @param options [Hash]
      # @return [Object]
      def object_from_response(klass, request_method, path, request_options={}, options ={})
        response = send(request_method.to_sym, path, request_options)
        klass.from_response(response, options)
      end

      # @param collection_name [Symbol]
      # @param klass [Class]
      # @param request_method [Symbol]
      # @param path [String]
      # @param request_options [Hash]
      # @return [TheCity::Collection]
      def collection_from_response(collection_name, klass, request_method, path, request_options)
        response = send(request_method.to_sym, path, request_options)
        TheCity::Collection.from_response(response, collection_name.to_sym, klass, self, request_method, path, request_options)
      end

    end
  end
end
