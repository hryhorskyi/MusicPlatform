# frozen_string_literal: true

module Invitations
  module Create
    class CheckExistingFriendship < Common::BaseInteractor
      def call
        return unless context.existing_invitation&.accepted_status?

        context.model.errors.add(:receiver_id, I18n.t('invitation.create.errors.already_friend'))
        context.fail!
      end
    end
  end
end
