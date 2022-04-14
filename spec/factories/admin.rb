# frozen_string_literal: true

FactoryBot.define do
  factory :admin do
    email { FFaker::Internet.email }
    password { Support::Helpers::PasswordCreatorHelper.call }
  end
end
