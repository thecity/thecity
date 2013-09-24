require 'the_city/error'

module TheCity
  class Error
    # Raised when The City returns the HTTP status code 504
    class GatewayTimeout < TheCity::Error
      HTTP_STATUS_CODE = 504
    end
  end
end
