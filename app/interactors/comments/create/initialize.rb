# frozen_string_literal: true

module Comments
  module Create
    class Initialize < Common::BaseInteractor
      def call
        context.model_class = Comment
        context.policy_class = CommentsPolicy
        context.policy_method = :create?
      end
    end
  end
end
