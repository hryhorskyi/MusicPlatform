# frozen_string_literal: true

module Invitations
  module Update
    class FindInvitation < Common::BaseInteractor
      def call
        context.model = find_invitation
        return if context.model.present?

        context.model = Invitation.new
        context.model.errors.add(:id, I18n.t('invitation.update.errors.invitation_not_exist'))
        context.fail!
      end

      private

      def find_invitation
        context.current_user.received_invitations.pending_status.find_by(id: context.params[:id])
      end
    end
  end
end
