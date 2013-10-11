module TheCity
  # The permissions associated with the current user
  #
  # @!attribute [r] can_list_in_plaza
  #   @return [Boolean] The name of the church, 'Grace Church'.
  # @!attribute [r] member
  #   @return [Boolean] The subdomain used to access this account, subdomain.onthecity.org
  # @!attribute [r] staff
  #   @return [Boolean] The id associated with the church account
  # @!attribute [r] admin
  #   @return [Boolean] The id associated with the church account
  # @!attribute [r] can_create_in_group_ids
  #   @return [Hash] The id associated with the church account
  # @!attribute [r] admin_privileges
  #   @return [Array] An array of admin privileges the user has on the current account

  class Permissions < TheCity::Base
    attr_reader :can_list_in_plaza, :member, :staff, :admin, :can_create_in_group_ids, :admin_privileges

    def is_account_admin?
      admin_privileges.any? {|ap| ap[:title] == 'Account Admin'} rescue false
    end

    def is_user_admin?
      admin_privileges.any? {|ap| ap[:title] == 'User Admin'} rescue false
    end

  end
end
