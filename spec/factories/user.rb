# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    nickname { FFaker::Lorem.characters(rand(User::NICKNAME_LENGTH)) }
    password { Support::Helpers::PassworCreatorHelper.call }
    password_confirmation { password }
  end
end
