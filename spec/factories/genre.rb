# frozen_string_literal: true

FactoryBot.define do
  factory :genre do
    name { FFaker::Music.genre }
  end
end
