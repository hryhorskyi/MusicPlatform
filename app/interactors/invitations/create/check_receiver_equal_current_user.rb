# frozen_string_literal: true

module Invitations
  module Create
    class CheckReceiverEqualCurrentUser < Common::BaseInteractor
      def call
        return if context.params[:receiver_id] != context.current_user.id

        context.model.errors.add(:receiver_id, I18n.t('invitation.create.errors.receiver_equal_current_user'))
        context.fail!
      end
    end
  end
end
