# frozen_string_literal: true

ALBUMS_QUANTITY = 10

after 'development:artists' do
  ALBUMS_QUANTITY.times do
    Album.create(name: FFaker::Music.album, artists: Artist.all.sample(2))
  end
end
