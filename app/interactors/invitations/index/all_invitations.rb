# frozen_string_literal: true

module Invitations
  module Index
    class AllInvitations < Common::BaseInteractor
      def call
        context.collection ||= context.current_user.invitations.pending_status
      end
    end
  end
end
