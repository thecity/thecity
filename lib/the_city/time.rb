require 'time'
#require 'tzinfo'
#require 'tzinfo-data'

module TheCity
  module Time

    # Time when the object was created
    #
    # @return [Time]
    def created_at
      @created_at ||= parse_or_at(@attrs[:created_at]) if @attrs[:created_at]
    end

    def created?
      !!@attrs[:created_at]
    end

    # Time when the object was updated
    #
    # @return [Time]
    def updated_at
      @updated_at ||= parse_or_at(@attrs[:updated_at]) if @attrs[:updated_at]
    end

    def updated?
      !!@attrs[:updated_at]
    end

    # Time when the object starts
    #
    # @return [Time]
    def starting_at
      @starting_at ||= parse_or_at(@attrs[:starting_at]) if @attrs[:starting_at]
    end

    def started?
      !!@attrs[:starting_at] and starting_at <= Time.now
    end

    # Time when the object ends
    #
    # @return [Time]
    def ending_at
      @ending_at ||= parse_or_at(@attrs[:ending_at]) if @attrs[:ending_at]
    end

    def ended?
      !!@attrs[:ending_at] and ending_at <= Time.now
    end

  private

    def parse_or_at(time)
      begin
        if time.is_a? Integer
          return Time.at(time).utc
        else
          return Time.parse(time).utc
        end
      rescue
        return nil
      end
    end

  end
end
