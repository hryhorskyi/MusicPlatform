# frozen_string_literal: true

FactoryBot.define do
  factory :album do
    name { FFaker::Music.album }
    association :artist
  end
end
