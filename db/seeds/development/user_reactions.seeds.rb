# frozen_string_literal: true

USER_REACTIONS_QUANTITY = 1

after 'development:playlists', 'development:users' do
  USER_REACTIONS_QUANTITY.times do
    UserReaction.create(user: User.all.sample,
                        playlist: Playlist.all.sample,
                        reaction: [0, 1].sample)
  end
end
