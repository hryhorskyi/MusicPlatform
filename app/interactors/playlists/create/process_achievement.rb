# frozen_string_literal: true

module Playlists
  module Create
    class ProcessAchievement < Common::BaseInteractor
      def call
        Achievements::PlaylistsCreateJob.perform_later(context.current_user.id)
      end
    end
  end
end
