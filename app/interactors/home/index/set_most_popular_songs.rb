# frozen_string_literal: true

module Home
  module Index
    class SetMostPopularSongs < Common::BaseInteractor
      SONGS_QUANTITY = 5

      def call
        context.model.most_popular_songs = find_songs
      end

      private

      def find_songs
        cached_song_ids = Rails.cache.fetch('popular_songs', expires_in: 5.minutes) { most_popular_song_ids }
        Song.where(id: cached_song_ids)
      end

      def most_popular_song_ids
        popular_songs = PlaylistSong.group('playlist_songs.song_id').order('count(playlist_songs.song_id) desc').count
        popular_songs.keys.first(SONGS_QUANTITY)
      end
    end
  end
end
