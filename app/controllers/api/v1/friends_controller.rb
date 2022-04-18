# frozen_string_literal: true

module Api
  module V1
    class FriendsController < ApiController
      before_action :authorize_access_request!, only: %i[create index]

      def index
        friends = current_user.initiated_friendships
                              .or(current_user.accepted_friendships).includes(:initiator, :acceptor)

        render json: FriendSerializer.new(friends, { include: %i[initiator acceptor] }), status: :ok
      end

      def create
        result = Friends::Create::Organizer.call(params: permitted_create_params, current_user: current_user)

        if result.success?
          render json: FriendSerializer.new(result.model, { include: %i[initiator acceptor] }), status: :created
        else
          render_errors(object: result.model, status: :unprocessable_entity)
        end
      end

      private

      def permitted_create_params
        params.permit(:invitation_id)
      end
    end
  end
end
