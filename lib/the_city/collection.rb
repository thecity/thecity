module TheCity
  # Utility class for collections with paged responses
  class Collection
    include Enumerable
    attr_reader :attrs
    alias to_h attrs
    alias to_hash attrs
    alias to_hsh attrs

    # Construct a new Collection object from a response hash
    #
    # @param response [Hash]
    # @param key [String, Symbol] The key to fetch the data from the response
    # @param klass [Class] The class to instantiate objects in the response
    # @param client [TheCity::API::Client]
    # @param request_method [String, Symbol]
    # @param path [String]
    # @param options [Hash]
    # @return [TheCity::Collection]
    def self.from_response(response, key, klass, client, request_method, path, options)
      new(response[:body], key, klass, client, request_method, path, options)
    end

    # Initializes a new Collection
    #
    # @param attrs [Hash]
    # @param key [String, Symbol] The key to fetch the data from the response
    # @param klass [Class] The class to instantiate objects in the response
    # @param client [TheCity::API::Client]
    # @param request_method [String, Symbol]
    # @param path [String]
    # @param options [Hash]
    # @return [TheCity::Collection]
    def initialize(attrs, key, klass, client, request_method, path, options)
      @key = key.to_sym
      @klass = klass
      @client = client
      @request_method = request_method.to_sym
      @path = path
      @options = options
      @collection = []
      set_attrs(attrs)
    end

    # @return [Enumerator]
    def each(start = 0, &block)
      return to_enum(:each) unless block_given?
      for element in Array(@collection[start..-1])
        yield element
        @current_cursor += 1
      end
      unless last?
        start = [@collection.size, start].max
        fetch_next_page unless last_page?
        each(start, &block)
      end
      @current_cursor = 1
      self
    end

    def current_cursor
      @current_cursor
    end

    def next_cursur
      (current_cursor + 1) || -1
    end
    alias next next_cursur

    def previous_cursor
      current_cursor - 1
    end
    alias previous previous_cursor

    # @return [Boolean]
    def first?
      previous_cursor.zero?
    end

    # @return [Boolean]
    def last?
      current_cursor >= total_entries
    end

    def current_page
      @current_page
    end

    def next_page
      current_page + 1
    end

    def last_page?
      current_page == @total_pages
    end

    def total_entries
      @total_entries.is_a?(Array) ? @total_entries.first : @total_entries
    end
    alias total total_entries

    def [](n)
      @collection[n]
    end

    def last
      @collection.last
    end

  private

    def fetch_next_page
      response = @client.send(@request_method, @path, @options.merge(:page => next_page, :per_page => @per_page))
      set_attrs(response[:body])
    end

    def set_attrs(attrs)
      @attrs = attrs
      for element in Array(attrs[@key])
        @collection << (@klass ? @klass.new(element) : element)
      end
      @total_entries = attrs[:total_entries],
      @current_page = attrs[:current_page],
      @total_pages = attrs[:total_pages],
      @per_page = attrs[:per_page],
      @current_cursor = ((@current_page - 1) * @per_page) + 1
    end

  end
end
