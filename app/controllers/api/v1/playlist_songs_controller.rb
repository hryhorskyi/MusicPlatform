# frozen_string_literal: true

module Api
  module V1
    class PlaylistSongsController < ApiController
      before_action :authorize_user!

      def create
        result = PlaylistSongs::Create::Organizer.call(current_user: current_user, params: create_permitted_params)

        if result.success?
          render json: PlaylistSerializer.new(result.model.playlist, { include: %i[songs] }), status: :created
        else
          render_errors(object: result.model, status: result.error_status)
        end
      end

      private

      def create_permitted_params
        params.permit(:playlist_id, :song_id)
      end
    end
  end
end
