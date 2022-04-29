# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    user { association(:user) }
    text { FFaker::Lorem.paragraph }
    playlist { association(:playlist) }
  end
end
