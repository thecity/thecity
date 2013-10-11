module TheCity
  class Group < TheCity::Base
    attr_reader :name, :type, :id, :profile_picture, :role_title, :primary_campus, :can_create

  end
end
