# frozen_string_literal: true

module Invitations
  module Create
    class CheckExistingInvitationIsPending < Common::BaseInteractor
      def call
        return unless context.existing_invitation&.pending_status?

        context.model.errors.add(:receiver_id, error_message)
        context.fail!
      end

      private

      def error_message
        if context.existing_invitation.requestor_id == context.current_user.id
          I18n.t('invitation.create.errors.you_already_invited')
        else
          I18n.t('invitation.create.errors.user_already_invited')
        end
      end
    end
  end
end
