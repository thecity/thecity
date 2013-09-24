require 'the_city/error'

module TheCity
  class Error
    # Raised when The City returns the HTTP status code 401
    class Unauthorized < TheCity::Error
      HTTP_STATUS_CODE = 401
    end
  end
end
