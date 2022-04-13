# frozen_string_literal: true

module Users
  module Index
    class FilterByFriends < Common::BaseInteractor
      def call
        return unless context.params[:exclude_friends] == 'true'

        context.collection = context.collection.where.not(id: friends_ids)
      end

      private

      def friends_ids
        friendships.pluck(:initiator_id, :acceptor_id).flatten.excluding(context.current_user.id)
      end

      def friendships
        @friendships ||= context.current_user.initiated_friendships.or(context.current_user.accepted_friendships)
      end
    end
  end
end
