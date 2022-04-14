# frozen_string_literal: true

module Friends
  module Create
    class CheckInvitationIsPending < Common::BaseInteractor
      def call
        return if context.invitation.pending_status?

        context.model.errors.add(:invitation_id, I18n.t('friends.create.errors.invite_not_pending'))
        context.fail!
      end
    end
  end
end
