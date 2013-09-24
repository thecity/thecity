module TheCity
	# The terminology overrides for a City account
  #
  # @!attribute [r] connect
  #   @return [String] The name this account uses for Connect groups.
  # @!attribute [r] campus
  #   @return [String] The name this account uses for Campus groups.
  # @!attribute [r] redemption
  #   @return [String] The name this account uses for Redemption groups.
  # @!attribute [r] seed
  #   @return [String] The name this account uses for Seed groups.
  # @!attribute [r] band
  #   @return [String] The name this account uses for Band groups.
  # @!attribute [r] other
  #   @return [String] The name this account uses for Other groups.
  # @!attribute [r] neighborhood
  #   @return [String] The name this account uses for Neighborhood groups.
  # @!attribute [r] network
  #   @return [String] The name this account uses for Network groups.
  # @!attribute [r] leader
  #   @return [String] The name this account uses for Leader groups.
  # @!attribute [r] community
  #   @return [String] The name this account uses for Community groups.
  # @!attribute [r] service
  #   @return [String] The name this account uses for Service groups.
  # @!attribute [r] church
  #   @return [String] The name this account uses for the Church group.
  # @!attribute [r] staff
  #   @return [String] The label this account uses for 'Staff'.
  # @!attribute [r] member
  #   @return [String] The label this account uses for 'Member'.
  # @!attribute [r] pledge
  #   @return [String] The label this account uses for 'Pledge'.
  class Terminology < TheCity::Base
    attr_reader :connect, :campus, :redemption, :member, :seed,
     :church, :service, :community, :staff, :pledge, :leader,
     :neighborhood, :other, :network, :band
  end
end
