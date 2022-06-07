# frozen_string_literal: true

module Comments
  module Index
    class FindPlaylist < Common::BaseInteractor
      def call
        context.model = Playlist.find_by(id: context.params[:playlist_id])

        return if context.model.present?

        context.fail!(error_status: :not_found)
      end
    end
  end
end
