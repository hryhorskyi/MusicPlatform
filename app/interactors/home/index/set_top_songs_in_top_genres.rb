# frozen_string_literal: true

module Home
  module Index
    class SetTopSongsInTopGenres < Common::BaseInteractor
      SONGS_QUANTITY = 10

      def call
        context.model.top_songs_in_top_genres = find_songs
      end

      private

      def find_songs
        Song.last(SONGS_QUANTITY)
      end
    end
  end
end
