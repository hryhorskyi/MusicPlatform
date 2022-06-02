# frozen_string_literal: true

module Friends
  module Destroy
    class FindPlaylists < Common::BaseInteractor
      def call
        context.current_user_shared_playlists = context.current_user.owned_playlists.shared_playlist_type
        context.friend_shared_playlists = context.friend.owned_playlists.shared_playlist_type
      end
    end
  end
end
