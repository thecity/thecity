require 'the_city/error'

module TheCity
  class Error
    # Raised when The City returns the HTTP status code 406
    class NotAcceptable < TheCity::Error
      HTTP_STATUS_CODE = 406
    end
  end
end
