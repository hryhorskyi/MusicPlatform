# frozen_string_literal: true

class UserReaction < ApplicationRecord
  belongs_to :user
  belongs_to :playlist

  validates :reaction, presence: true

  enum reaction: { unlike: 0, like: 1 }, _suffix: true
end
