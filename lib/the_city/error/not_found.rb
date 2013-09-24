require 'the_city/error'

module TheCity
  class Error
    # Raised when The City returns the HTTP status code 404
    class NotFound < TheCity::Error
      HTTP_STATUS_CODE = 404
    end
  end
end
