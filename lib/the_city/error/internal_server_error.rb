require 'the_city/error'

module TheCity
  class Error
    # Raised when The City returns the HTTP status code 500
    class InternalServerError < TheCity::Error
      HTTP_STATUS_CODE = 500
    end
  end
end
