# frozen_string_literal: true

module PlaylistSongs
  module Create
    class Initialize < Common::BaseInteractor
      def call
        context.model_class = PlaylistSong
        context.policy_class = PlaylistSongsPolicy
        context.policy_method = :create?
      end
    end
  end
end
