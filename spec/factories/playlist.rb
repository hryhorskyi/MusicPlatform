# frozen_string_literal: true

FactoryBot.define do
  factory :playlist do
    sequence(:name) { |n| FFaker::Music.album + n.to_s }
    description { FFaker::Lorem.sentence }
    playlist_type { Playlist.playlist_types.values.first }
    owner { association(:user) }

    trait :public do
      playlist_type { 'public' }
    end

    trait :shared do
      playlist_type { 'shared' }
    end

    trait :private do
      playlist_type { 'private' }
    end
  end
end
