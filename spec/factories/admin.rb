# frozen_string_literal: true

FactoryBot.define do
  factory :admin do
    email { FFaker::Internet.email }

    password do
      FFaker::Internet.password.delete('_') + %w[@ $ ! % * ? &].sample + rand(10).to_s
    end
  end
end
