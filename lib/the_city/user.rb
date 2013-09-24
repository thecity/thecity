module TheCity
  class User < TheCity::Base
    extend Forwardable

    attr_reader :id, :name, :profile_picture, :gender
    attr_writer :permissions

    def_delegators :@permissions, :member?, :staff?, :admin?

    # Returns the groups that the user belongs to
    #
    # @return [Array<TheCity::Group>]
    def groups
      memoize(:groups) do
        Array(@attrs[:groups]).map do |g|
          TheCity::Group.new(g)
        end
      end
    end

    # Returns the permissions for the current user
    #
    # @return [TheCity::Permissions]
    def permissions
      @permissions ||= @client.permissions if (@client and @client.current_user.id == id)
    end

    # def member?
    #   permissions.member? rescue false
    # end

    # def staff?
    #   permissions.staff? rescue false
    # end

    # def admin?
    #   permissions.admin? rescue false
    # end

  end
end
