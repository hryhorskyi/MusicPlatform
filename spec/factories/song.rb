# frozen_string_literal: true

FactoryBot.define do
  factory :song do
    name { FFaker::Music.song }
    featured { [true, false].sample }
    album { association(:album) }
  end
end
