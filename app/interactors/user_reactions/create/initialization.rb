# frozen_string_literal: true

module UserReactions
  module Create
    class Initialization < Common::BaseInteractor
      def call
        context.model_class = UserReaction
        context.policy_class = UserReactionPolicy
        context.policy_method = :create?
      end
    end
  end
end
