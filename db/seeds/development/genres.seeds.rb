# frozen_string_literal: true

FFaker::Music::GENRES.each do |genre|
  Genre.create(name: genre)
end
