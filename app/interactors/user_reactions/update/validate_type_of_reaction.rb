# frozen_string_literal: true

module UserReactions
  module Update
    class ValidateTypeOfReaction < Common::BaseInteractor
      def call
        return if UserReaction.reactions.key?(context.params[:reaction])

        context.model.errors.add(:reaction, I18n.t('user_reactions.update.errors.invalid_reaction'))
        context.fail!(error_status: :unprocessable_entity)
      end
    end
  end
end
