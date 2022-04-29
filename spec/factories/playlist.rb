# frozen_string_literal: true

FactoryBot.define do
  factory :playlist do
    name { FFaker::Music.album }
    description { FFaker::Lorem.paragraph }
    playlist_type { Playlist.playlist_types.values.first }
    owner { association(:user) }
  end
end
