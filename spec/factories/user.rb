# frozen_string_literal: true

PASSWORD_CHARS = %w[@ $ ! % * ? &].freeze
PASSWORD_NUMBERS = (0..9)

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    password { FFaker::Internet.password.delete('_') + PASSWORD_CHARS.sample + rand(PASSWORD_NUMBERS).to_s }
    password_confirmation { password }
    nickname { FFaker::Lorem.characters(rand(User::NICKNAME_LENGTH)) }
  end
end
