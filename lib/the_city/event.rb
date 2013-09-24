require 'the_city/content'

module TheCity
  
  # class for content of type 'Event'
  #
  class Event < TheCity::Content
  	attr_reader :timezone
  end

end
