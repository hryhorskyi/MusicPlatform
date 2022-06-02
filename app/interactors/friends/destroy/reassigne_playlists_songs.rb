# frozen_string_literal: true

module Friends
  module Destroy
    class ReassignePlaylistsSongs < Common::BaseInteractor
      def call
        return unless context.params[:keep_songs] == 'true'

        reassigne_songs_to_current_user
        reassigne_songs_to_friend
      end

      private

      def reassigne_songs_to_current_user
        playlists_songs(context.friend, context.current_user_shared_playlists).update(user_id: context.current_user.id)
      end

      def reassigne_songs_to_friend
        playlists_songs(context.current_user, context.friend_shared_playlists).update(user_id: context.friend.id)
      end

      def playlists_songs(user, playlists)
        user.playlist_songs.where(playlist: playlists)
      end
    end
  end
end
