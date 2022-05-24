# frozen_string_literal: true

module Home
  module Index
    class SetTopContributors < Common::BaseInteractor
      CONTRIBUTORS_QUANTITY = 5

      def call
        context.model.top_contributors = find_contributors
      end

      private

      def find_contributors
        User.last(CONTRIBUTORS_QUANTITY)
      end
    end
  end
end
