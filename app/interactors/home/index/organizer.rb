# frozen_string_literal: true

module Home
  module Index
    class Organizer < Common::BaseOrganizer
      organize SetBaseModel,
               SetLatestPublicPlaylists,
               SetLatestSongs,
               SetMostPopularPlaylists,
               SetMostPopularSongs,
               SetPeopleWithMostFriends,
               SetTopContributors,
               SetTopFeaturedPublicPlaylists,
               SetTopSongsInTopGenres
    end
  end
end
