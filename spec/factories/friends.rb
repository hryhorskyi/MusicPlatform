# frozen_string_literal: true

FactoryBot.define do
  factory :friend do
    initiator_id { FFaker::UniqueUtils.new(FFaker.number(1..10), 5) }
    acceptor_id { FFaker::UniqueUtils.new(FFaker.number(1..10), 5) }
  end
end
