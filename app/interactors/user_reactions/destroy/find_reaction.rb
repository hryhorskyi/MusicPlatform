# frozen_string_literal: true

module UserReactions
  module Destroy
    class FindReaction < Common::BaseInteractor
      def call
        context.model = UserReaction.find_by(id: context.params[:id])
        return if context.model.present?

        context.fail!(error_status: :not_found)
      end
    end
  end
end
