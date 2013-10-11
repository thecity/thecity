require 'the_city/content'

module TheCity
  
  # class for content of type 'Topic'
  #
  class Topic < TheCity::Content
  end

  def valid?
  	return (title and body and group_id)
  end

end
