# frozen_string_literal: true

module Api
  module V1
    class UserReactionsController < ApiController
      before_action :authorize_access_request!

      def create
        result = UserReactions::Create::Organizer.call(current_user: current_user, params: permitted_create_params)

        if result.success?
          render json: PlaylistSerializer.new(result.model.playlist), status: :created
        else
          render_errors(object: result.model, status: result.error_status)
        end
      end

      private

      def permitted_create_params
        params.permit(:playlist_id, :reaction)
      end
    end
  end
end
