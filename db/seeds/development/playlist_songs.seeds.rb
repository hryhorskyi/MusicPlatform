# frozen_string_literal: true

PLAYLIST_SONGS_QUANTITY = 20

after 'development:songs', 'development:users', 'development:playlists' do
  PLAYLIST_SONGS_QUANTITY.times do
    PlaylistSong.create(song: Song.all.sample,
                        user: User.all.sample,
                        playlist: Playlist.all.sample)
  end
end
