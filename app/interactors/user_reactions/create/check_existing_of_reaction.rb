# frozen_string_literal: true

module UserReactions
  module Create
    class CheckExistingOfReaction < Common::BaseInteractor
      def call
        return unless context.playlist.user_reactions.exists?(user: context.current_user)

        context.model.errors.add(:reaction, I18n.t('user_reactions.create.errors.exist'))
        context.fail!(error_status: :unprocessable_entity)
      end
    end
  end
end
