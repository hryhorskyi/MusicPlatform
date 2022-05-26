# frozen_string_literal: true

module UserReactions
  module Destroy
    class Initialization < Common::BaseInteractor
      def call
        context.policy_class = UserReactionPolicy
        context.policy_method = :destroy?
      end
    end
  end
end
