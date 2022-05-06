# frozen_string_literal: true

module Api
  module V1
    class PlaylistsController < ApiController
      before_action :authorize_access_request!

      def create
        result = Playlists::Create::Organizer.call(current_user: current_user, params: permitted_create_params)

        if result.success?
          render json: PlaylistSerializer.new(result.model), status: :created
        else
          render_errors(object: result.model, status: :unprocessable_entity)
        end
      end

      def destroy
        result = Playlists::Destroy::Organizer.call(current_user: current_user, params: permitted_destroy_params)

        if result.success?
          render status: :no_content
        else
          render status: :not_found
        end
      end

      private

      def permitted_destroy_params
        params.permit(:id)
      end

      def permitted_create_params
        params.require(:playlist).permit(:name, :description, :playlist_type)
      end
    end
  end
end
