require 'the_city/error'

module TheCity
  class Error
    # Raised when The City returns the HTTP status code 503
    class ServiceUnavailable < TheCity::Error
      HTTP_STATUS_CODE = 503
    end
  end
end
