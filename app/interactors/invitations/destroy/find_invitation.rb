# frozen_string_literal: true

module Invitations
  module Destroy
    class FindInvitation < Common::BaseInteractor
      def call
        context.model = invitation

        return if context.model.present?

        context.fail!
      end

      private

      def invitation
        context.current_user.sent_invitations.pending_status.find_by(id: context.params[:id])
      end
    end
  end
end
