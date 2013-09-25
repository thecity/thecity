require 'the_city/arguments'
require 'the_city/api/utils'
require 'the_city/account'

module TheCity
  module API
    module Accounts
      include TheCity::API::Utils
      
      # Returns the current City account associated with the current user
      #
      # @req_scope none
      # @return [TheCity::Account]
      # @param options [Hash] A customizable set of options.
      def church_account(options={})
        @church_account = nil if options.delete(:force_download)
        @church_account ||= object_from_response(TheCity::Account, :get, "/church_account", options)
      end
      alias current_account church_account
      alias current_church church_account

      # Returns an array of all the City accounts associated with the current user
      #
      # @req_scope none
      # @return [Array<TheCity::Account>] 
      # @param options [Hash] A customizable set of options.
      def my_accounts(options={})
        @my_accounts = nil if options.delete(:force_download)
        @my_accounts ||= objects_from_response(TheCity::Account, :get, "/me/accounts", options)
      end

    end
  end
end
