require 'time'

module TheCity
  class User < TheCity::Base
    attr_reader :id, :title, :first, :last, :name, :profile_picture, #user_basic
                :gender, :email ##user_extended
    attr_writer :permissions

    # Returns the groups that the user belongs to
    #
    # @return [Array<TheCity::Group>]
    def groups
      memoize(:groups) do
        if @attrs[:groups].any?
          Array(@attrs[:groups]).map do |g|
            TheCity::Group.new(g)
          end
        elsif @client
          @client.my_groups
        else
          []
        end
      end
    end

    def method_missing(method_sym, *arguments, &block)
      if method_sym.to_s =~ /^is_in_group_(\d+)\??$/
        is_in_group_with_title?($1.to_i, arguments.first)
      else
        super
      end
    end

    # @note Returns true/false if the current user has an active role in the group (group_id).
    #
    # @param group_id [Integer] the id of TheCity::Group in question.
    # @param title [Array<String>] the title or titles of the user's active role.
    # @example see if the user is a leader in group 1234
    #   current_user.is_in_group_with_title(1234, :leader)
    # @return [Boolean]
    def is_in_group_with_title?(group_id, title=nil)
      return groups.any? {|g| g.id == group_id } if title.nil?
      titles = [title].flatten
      return groups.any? {|g| (g.id == group_id and titles.any? {|t| t.to_s.downcase == g.role_title.downcase } ) }
    end

    # Returns the user's birthdate as a ruby Date object.
    #
    # @return [Date]
    def birthdate
      @bday ||= Date.strptime(@attrs[:birthdate], '%m/%d/%Y') rescue nil
    end

    # Returns the permissions for the current user
    #
    # @return [TheCity::Permissions]
    def permissions
      @permissions ||= @client.permissions if (@client and @client.current_user.id == id)
    end

    # Returns true/false if the current user is an admin on the current church (Group Admin, Account Admin, etc).
    # If you need to check for a specific admin privilege, you will need to go through TheCity::Permissions object.
    #
    # @return [Boolean]
    def admin?
      @attrs[:admin] || permissions.admin? rescue nil
    end

    # Returns true/false if the current user is a member of the current church.
    #
    # @return [Boolean]
    def member?
      @attrs[:member] || permissions.member? rescue nil
    end

    # Returns true/false if the current user is on staff at the current church.
    #
    # @return [Boolean]
    def staff?
      @attrs[:staff] || permissions.staff? rescue nil
    end

  end
end
