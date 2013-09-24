require 'the_city/base'

module TheCity
  class Token < TheCity::Base
    attr_reader :access_token, :token_type
    alias to_s access_token

    BEARER_TYPE = "bearer"

    # @return [Boolean]
    def bearer?
      @attrs[:token_type] == BEARER_TYPE
    end

  end
end
