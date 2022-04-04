# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    nickname { FFaker::Lorem.characters(rand(User::NICKNAME_LENGTH)) }

    password do
      FFaker::Internet.password.delete('_') + %w[@ $ ! % * ? &].sample + rand(10).to_s
    end

    password_confirmation { password }
  end
end
