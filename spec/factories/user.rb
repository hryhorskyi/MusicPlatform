# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    nickname { FFaker::Lorem.characters(rand(User::NICKNAME_LENGTH)) }
    password { Support::Helpers::PasswordCreatorHelper.call }
    password_confirmation { password }

    first_name { FFaker::Lorem.characters(rand(User::NICKNAME_LENGTH)) }
    last_name { FFaker::Lorem.characters(rand(User::NICKNAME_LENGTH)) }
    avatar { FFaker::Lorem.characters(rand(User::NICKNAME_LENGTH)) }
  end
end
