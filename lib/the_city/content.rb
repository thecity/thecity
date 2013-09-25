require 'the_city/time'

module TheCity
  # Base class for The City content types: Topics, Events, Prayers, Needs, and Albums
  #
  # @!attribute [r] title
  #   @return [String] The title of the post.
  # @!attribute [r] body
  #   @return [String] The body text of the post.
  # @!attribute [r] id
  #   @return [Integer] The id associated with the church account.
  # @!attribute [r] group
  #   @return [TheCity::Group] The group where the content originated.
  # @!attribute [r] author
  #   @return [TheCity::User] The user who posted the content.

  class Content < TheCity::Base
    include TheCity::Time
    attr_reader :id, :title, :body
    object_attr_reader :User, :user
    object_attr_reader :Group, :group

    # def user
    #   @user
    # end
    alias author user
    
  end
end
