# frozen_string_literal: true

module Invitations
  module Index
    class FilterByReceiver < Common::BaseInteractor
      def call
        return unless context.params[:role_filter] == 'receiver'

        context.collection = context.current_user.received_invitations.pending_status
      end
    end
  end
end
