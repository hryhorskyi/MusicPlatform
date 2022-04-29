# frozen_string_literal: true

FactoryBot.define do
  factory :playlist_song do
    user { association(:user) }
    song { association(:song) }
    playlist { association(:playlist) }
  end
end
