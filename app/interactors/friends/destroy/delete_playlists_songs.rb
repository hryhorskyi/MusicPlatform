# frozen_string_literal: true

module Friends
  module Destroy
    class DeletePlaylistsSongs < Common::BaseInteractor
      def call
        return if context.params[:keep_songs] == 'true'

        delete_friend_songs
        delete_current_user_songs
      end

      private

      def delete_friend_songs
        playlists_songs(context.friend,
                        context.current_user_shared_playlists).where(user_id: context.friend.id).map(&:destroy!)
      end

      def delete_current_user_songs
        playlists_songs(context.current_user,
                        context.friend_shared_playlists).where(user_id: context.current_user.id).map(&:destroy!)
      end

      def playlists_songs(user, playlists)
        user.playlist_songs.where(playlist: playlists)
      end
    end
  end
end
