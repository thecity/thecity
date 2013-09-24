require 'the_city/error'

module TheCity
  class Error
    # Raised when The City returns the HTTP status code 429
    class TooManyRequests < TheCity::Error
      HTTP_STATUS_CODE = 429
    end
    EnhanceYourCalm = TooManyRequests
    RateLimited = TooManyRequests
  end
end
