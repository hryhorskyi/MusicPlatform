# frozen_string_literal: true

module Home
  module Index
    class SetPeopleWithMostFriends < Common::BaseInteractor
      PEOPLE_QUANTITY = 5

      def call
        context.model.people_with_most_friends = find_people
      end

      private

      def find_people
        User.last(PEOPLE_QUANTITY)
      end
    end
  end
end
