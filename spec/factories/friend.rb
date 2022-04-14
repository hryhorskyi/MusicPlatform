# frozen_string_literal: true

FactoryBot.define do
  factory :friend do
    initiator { association(:user) }
    acceptor { association(:user) }
  end
end
