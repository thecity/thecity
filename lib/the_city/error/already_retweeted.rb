require 'the_city/error/forbidden'

module TheCity
  class Error
    # Raised when a Tweet has already been retweeted
    class AlreadyRetweeted < TheCity::Error::Forbidden
      MESSAGE = "sharing is not permissible for this status (Share validations failed)"
    end
  end
end
