# frozen_string_literal: true

module UserReactions
  module Update
    class CheckChangingOfReaction < Common::BaseInteractor
      def call
        return if context.model.reaction != context.params[:reaction]

        context.model.errors.add(:reaction, I18n.t('user_reactions.update.errors.same_reaction'))
        context.fail!(error_status: :unprocessable_entity)
      end
    end
  end
end
