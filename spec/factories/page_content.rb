# frozen_string_literal: true

FactoryBot.define do
  factory :page_content do
    page_slug { FFaker::Lorem.word }
  end
end
