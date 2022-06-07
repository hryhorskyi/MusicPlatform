# frozen_string_literal: true

module Comments
  module Index
    class Initialize < Common::BaseInteractor
      Pagy::DEFAULT[:items] = 30

      def call
        context.policy_class = CommentsIndexPolicy
        context.policy_method = :index?
      end
    end
  end
end
