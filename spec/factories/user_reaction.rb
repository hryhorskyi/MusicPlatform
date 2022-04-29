# frozen_string_literal: true

FactoryBot.define do
  factory :user_reaction do
    user { association(:user) }
    playlist { association(:playlist) }
    reaction { UserReaction.reactions.values.first }
  end
end
