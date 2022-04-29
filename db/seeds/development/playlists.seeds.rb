# frozen_string_literal: true

PLAYLISTS_QUANTITY = 10

after 'development:users' do
  PLAYLISTS_QUANTITY.times do
    Playlist.create(name: FFaker::Music.album,
                    description: FFaker::Lorem.paragraph,
                    playlist_type: [0, 1, 2].sample,
                    logo: 'DUMMY',
                    owner: User.all.sample)
  end
end
