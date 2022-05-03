# frozen_string_literal: true

module Api
  module V1
    class PlaylistsController < ApiController
      before_action :authorize_access_request!

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
    end
  end
end
