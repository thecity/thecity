require 'the_city/error'

module TheCity
  class Error
    # Raised when The City returns the HTTP status code 403
    class Forbidden < TheCity::Error
      HTTP_STATUS_CODE = 403
    end
  end
end
