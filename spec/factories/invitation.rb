# frozen_string_literal: true

FactoryBot.define do
  factory :invitation do
    receiver { association(:user) }
    requestor { association(:user) }
  end
end
