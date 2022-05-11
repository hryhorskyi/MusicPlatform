# frozen_string_literal: true

SONGS_QUANTITY = 20

after 'development:artists', 'development:genres', 'development:albums' do
  SONGS_QUANTITY.times do
    album = Album.all.sample
    main_artist = album.artists.first

    album.songs.create(name: FFaker::Music.song,
                       featured: FFaker::Boolean.random,
                       artists: [Artist.all.sample, main_artist].uniq,
                       genres: Genre.all.sample(2))
  end
end
