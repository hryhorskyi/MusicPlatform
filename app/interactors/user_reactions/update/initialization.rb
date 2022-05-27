# frozen_string_literal: true

module UserReactions
  module Update
    class Initialization < Common::BaseInteractor
      def call
        context.model_class = UserReaction
        context.policy_class = UserReactionPolicy
        context.policy_method = :update?
      end
    end
  end
end
