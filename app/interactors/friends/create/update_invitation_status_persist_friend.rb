# frozen_string_literal: true

module Friends
  module Create
    class UpdateInvitationStatusPersistFriend < Common::BaseInteractor
      def call
        ActiveRecord::Base.transaction do
          context.invitation.accepted_status!
          Common::Model::Persist.call(model: context.model)
        rescue ActiveRecord::RecordInvalid
          context.model.errors.add(:friendship, I18n.t('friends.create.errors.persist_rollback'))
          context.fail!
        end
      end
    end
  end
end
