# frozen_string_literal: true

module Invitations
  module Create
    class CheckRecentlyDeclined < Common::BaseInteractor
      def call
        return unless invitation_declined_status? && invitation_declined_at_expired?

        context.model.errors.add(:receiver_id, I18n.t('invitation.create.errors.declined_recently'))
        context.fail!
      end

      private

      def invitation_declined_status?
        context.existing_invitation&.declined_status?
      end

      def invitation_declined_at_expired?
        context.existing_invitation.declined_at > Invitation::DECLINED_AT_EXPIRATION_TIME.ago
      end
    end
  end
end
