# frozen_string_literal: true

module Common
  module Policy
    class Check < Common::BaseInteractor
      def call
        return if policy.try(context.policy_method)

        context.fail!(error_status: :forbidden)
      end

      private

      def policy
        @policy ||= context.policy_class.new(context.current_user, context.model)
      end
    end
  end
end
