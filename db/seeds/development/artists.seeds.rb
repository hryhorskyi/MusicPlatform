# frozen_string_literal: true

ARTISTS_QUANTITY = 5

ARTISTS_QUANTITY.times do
  Artist.create(name: FFaker::Name.name)
end
