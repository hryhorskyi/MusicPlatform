# frozen_string_literal: true

module UserReactions
  module Update
    class FindPlaylist < Common::BaseInteractor
      def call
        context.playlist = Playlist.find_by(id: context.params[:playlist_id])
        return if context.playlist.present?

        context.fail!(error_status: :not_found)
      end
    end
  end
end
