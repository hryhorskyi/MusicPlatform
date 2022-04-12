# frozen_string_literal: true

module Invitations
  module Create
    class FindReceiver < Common::BaseInteractor
      def call
        context.receiver = User.find_by(id: context.params[:receiver_id])
        return if context.receiver.present?

        context.model.errors.add(:receiver_id, I18n.t('invitation.create.errors.user_not_exist'))
        context.fail!
      end
    end
  end
end
