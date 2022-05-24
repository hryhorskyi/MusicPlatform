# frozen_string_literal: true

module Home
  module Index
    class SetMostPopularPlaylists < Common::BaseInteractor
      PLAYLISTS_QUANTITY = 5

      def call
        context.model.most_popular_playlists = find_playlists
      end

      private

      def find_playlists
        Playlist.last(PLAYLISTS_QUANTITY)
      end
    end
  end
end
