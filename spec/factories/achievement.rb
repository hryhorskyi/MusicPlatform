# frozen_string_literal: true

FactoryBot.define do
  factory :achievement do
    achievement_type { Achievement.achievement_types.values.sample }
    user { association(:user) }
    actual_count { Achievement::CREADTED_PLAYLISTS_ACHIEVEMENTS_COUNT.sample }
  end
end
