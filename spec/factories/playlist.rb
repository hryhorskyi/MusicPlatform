# frozen_string_literal: true

FactoryBot.define do
  factory :playlist do
    sequence(:name) { |n| FFaker::Music.album + n.to_s }
    description { FFaker::Lorem.paragraph }
    playlist_type { Playlist.playlist_types.values.first }
    owner { association(:user) }
  end
end
