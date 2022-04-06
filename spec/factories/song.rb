# frozen_string_literal: true

FactoryBot.define do
  factory :song do
    name { FFaker::Music.song }
    featured { [true, false].sample }
    album_id { FFaker::UniqueUtils.new(FFaker.number(1..10), 5) }
  end
end
