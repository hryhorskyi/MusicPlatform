# frozen_string_literal: true

FactoryBot.define do
  factory :artist do
    name { FFaker::Name.name }
  end
end
