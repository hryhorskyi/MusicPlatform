# frozen_string_literal: true

module PlaylistSongs
  module Create
    class FindSong < Common::BaseInteractor
      def call
        context.song = Song.find_by(id: context.params[:song_id])
        return if context.song.present?

        context.fail!(error_status: :not_found)
      end
    end
  end
end
