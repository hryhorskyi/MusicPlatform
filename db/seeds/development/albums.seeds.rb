# frozen_string_literal: true

ALBUMS_QUANTITY = 10

after 'development:artists' do
  ALBUMS_QUANTITY.times { Artist.all.sample.albums.create(name: FFaker::Music.album) }
end
