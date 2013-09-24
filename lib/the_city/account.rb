module TheCity
  # The City church account
  #
  # @!attribute [r] name
  #   @return [String] The name of the church, 'Grace Church'.
  # @!attribute [r] subdomain
  #   @return [String] The subdomain used to access this account, subdomain.onthecity.org
  # @!attribute [r] id
  #   @return [Integer] The id associated with the church account

  class Account < TheCity::Base
    attr_reader :name, :id, :subdomain
    object_attr_reader :Terminology, :terminology

    def initialize(attrs={}, options={})
      super(attrs,options)
      @campuses = Array(attrs.delete(:campuses)).map {|g| TheCity::Group.new(g,options)}
    end

    # Return campuses that belong to a multisite church
    #
    # @return [Array<TheCity::Group>]
    def campuses
      @campuses
    end

  end
end
