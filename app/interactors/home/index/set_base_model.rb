# frozen_string_literal: true

module Home
  module Index
    class SetBaseModel < Common::BaseInteractor
      def call
        context.model = Struct.new(:id,
                                   :latest_public_playlists,
                                   :latest_songs,
                                   :most_popular_playlists,
                                   :most_popular_songs,
                                   :people_with_most_friends,
                                   :top_contributors,
                                   :top_featured_public_playlists,
                                   :top_songs_in_top_genres).new
      end
    end
  end
end
