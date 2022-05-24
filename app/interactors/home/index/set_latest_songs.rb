# frozen_string_literal: true

module Home
  module Index
    class SetLatestSongs < Common::BaseInteractor
      SONGS_QUANTITY = 5

      def call
        context.model.latest_songs = find_songs
      end

      private

      def find_songs
        Song.last(SONGS_QUANTITY)
      end
    end
  end
end
