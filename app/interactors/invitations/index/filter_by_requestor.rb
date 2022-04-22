# frozen_string_literal: true

module Invitations
  module Index
    class FilterByRequestor < Common::BaseInteractor
      def call
        return unless context.params[:role_filter] == 'requestor'

        context.collection = context.current_user.sent_invitations.pending_status
      end
    end
  end
end
