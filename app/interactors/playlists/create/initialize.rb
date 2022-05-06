# frozen_string_literal: true

module Playlists
  module Create
    class Initialize < Common::BaseInteractor
      def call
        context.model_class = Playlist
      end
    end
  end
end
