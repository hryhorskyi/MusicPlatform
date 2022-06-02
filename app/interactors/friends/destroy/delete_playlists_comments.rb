# frozen_string_literal: true

module Friends
  module Destroy
    class DeletePlaylistsComments < Common::BaseInteractor
      def call
        return if context.params[:keep_comments] == 'true'

        delete_friend_comments
        delete_current_user_comments
      end

      private

      def delete_friend_comments
        context.friend.comments.where(playlist: context.current_user_shared_playlists).map(&:destroy!)
      end

      def delete_current_user_comments
        context.current_user.comments.where(playlist: context.friend_shared_playlists).map(&:destroy!)
      end
    end
  end
end
