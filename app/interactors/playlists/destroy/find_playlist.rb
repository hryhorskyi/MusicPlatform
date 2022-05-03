# frozen_string_literal: true

module Playlists
  module Destroy
    class FindPlaylist < Common::BaseInteractor
      def call
        context.model = playlist

        return if context.model.present?

        context.fail!
      end

      private

      def playlist
        context.current_user.owned_playlists.find_by(id: context.params[:id])
      end
    end
  end
end
