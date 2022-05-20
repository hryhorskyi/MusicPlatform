# frozen_string_literal: true

module Users
  module Destroy
    class Initialize < Common::BaseInteractor
      def call
        context.model_class = User
        context.policy_class = UsersPolicy
        context.policy_method = :destroy?
      end
    end
  end
end
