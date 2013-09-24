require 'the_city/error'

module TheCity
  class Error
    # Raised when The City returns the HTTP status code 502
    class BadGateway < TheCity::Error
      HTTP_STATUS_CODE = 502
    end
  end
end
