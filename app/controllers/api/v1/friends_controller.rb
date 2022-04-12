# frozen_string_literal: true

module Api
  module V1
    class FriendsController < ApiController
      before_action :authorize_access_request!, only: %i[index]

      def index
        friends = current_user.initiated_friendships
                              .or(current_user.accepted_friendships).includes(:initiator, :acceptor)

        render json: FriendSerializer.new(friends, { include: %i[initiator acceptor] }), status: :ok
      end
    end
  end
end
