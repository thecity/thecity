require 'the_city/error'

module TheCity
  class Error
    # Raised when The City returns the HTTP status code 422
    class UnprocessableEntity < TheCity::Error
      HTTP_STATUS_CODE = 422
    end
  end
end
