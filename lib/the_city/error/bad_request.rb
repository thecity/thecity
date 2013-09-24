require 'the_city/error'

module TheCity
  class Error
    # Raised when The City returns the HTTP status code 400
    class BadRequest < TheCity::Error
      HTTP_STATUS_CODE = 400
    end
  end
end
