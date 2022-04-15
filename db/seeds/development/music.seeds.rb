# frozen_string_literal: true

# Artists
5.times do
  name = FFaker::Name.name
  Artist.create(name: name)
end

# Random Albums
9.times do
  name      = FFaker::Music.album
  artist_id = 1.upto(5).to_a.sample
  Album.create(name: name, artist_id: artist_id)
end

# 1 Album with several artist_id's
name        = FFaker::Music.album
artists_ids = 1.upto(5).to_a.sample(2)
Album.create(name: name, artist_id: artists_ids)

# Genres
%w[Blues Children Classical Comedy/Spoken Country Easy Listening
   Electronic Folk Holiday International Jazz Latin New Age Pop/Rock
   R&B Rap Reggae Religious Stage & Screen Vocal].map do |genre|
  Genre.create(name: genre)
end

# Songs
20.times do
  name     = FFaker::Music.song
  featured = [true, false].sample
  album_id = 1.upto(10).to_a.sample
  Song.create(name: name, featured: featured, album_id: album_id)
end
