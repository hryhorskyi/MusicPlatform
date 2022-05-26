# frozen_string_literal: true

module PlaylistSongs
  module Create
    class BuildAttributes < Common::BaseInteractor
      def call
        context.model_params = context.params.merge({ user: context.current_user,
                                                      playlist_id: context.params[:playlist_id],
                                                      song_id: context.params[:song_id] })
      end
    end
  end
end
