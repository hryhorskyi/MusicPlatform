# frozen_string_literal: true

module Home
  module Index
    class SetLatestPublicPlaylists < Common::BaseInteractor
      PLAYLISTS_QUANTITY = 5

      def call
        context.model.latest_public_playlists = find_playlists
      end

      private

      def find_playlists
        Playlist.last(PLAYLISTS_QUANTITY)
      end
    end
  end
end
