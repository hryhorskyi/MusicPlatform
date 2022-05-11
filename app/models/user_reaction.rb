# frozen_string_literal: true

class UserReaction < ApplicationRecord
  belongs_to :user
  belongs_to :playlist

  validates :user_id, uniqueness: { scope: :playlist_id }
  validates :reaction, presence: true

  enum reaction: { dislike: 0, like: 1 }, _suffix: true
end
