# frozen_string_literal: true

FactoryBot.define do
  factory :invitation do
    requestor_id { FFaker::UniqueUtils.new(FFaker.number(1..10), 5) }
    receiver_id { FFaker::UniqueUtils.new(FFaker.number(1..10), 5) }
    status { FFaker::UniqueUtils.new(FFaker.number(0..2), 1) }
  end
end
