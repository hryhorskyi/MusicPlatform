# frozen_string_literal: true

module MyAccount
  module Update
    class ValidateNicknameUniqueness < Common::BaseInteractor
      def call
        return if nickname_unique?(context.current_user)

        context.model.errors.add(:nickname, I18n.t('my_account.update.errors.nickname_exist'))
        context.fail!
      end

      private

      def nickname_unique?(user)
        !User.where.not(id: user.id).exists?(nickname: context.params[:nickname])
      end
    end
  end
end
