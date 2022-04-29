# frozen_string_literal: true

COMMENTS_QUANTITY = 10

after 'development:playlists', 'development:users' do
  COMMENTS_QUANTITY.times do
    playlist = Playlist.all.sample

    playlist.comments.create(user: User.all.sample,
                             text: FFaker::Lorem.paragraph,
                             playlist: playlist)
  end
end
