# frozen_string_literal: true

module Home
  module Index
    class SetTopFeaturedPublicPlaylists < Common::BaseInteractor
      PLAYLISTS_QUANTITY = 5

      def call
        context.model.top_featured_public_playlists = find_playlists
      end

      private

      def find_playlists
        Playlist.last(PLAYLISTS_QUANTITY)
      end
    end
  end
end
