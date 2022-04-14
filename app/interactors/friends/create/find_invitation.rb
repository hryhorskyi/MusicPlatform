# frozen_string_literal: true

module Friends
  module Create
    class FindInvitation < Common::BaseInteractor
      def call
        context.invitation = invitation

        return if context.invitation.present?

        context.model.errors.add(:invitation_id, I18n.t('friends.create.errors.invite_not_exist'))
        context.fail!
      end

      private

      def invitation
        context.current_user.received_invitations.find_by(id: context.params[:invitation_id])
      end
    end
  end
end
