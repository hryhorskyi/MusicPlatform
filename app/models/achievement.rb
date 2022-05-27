# frozen_string_literal: true

class Achievement < ApplicationRecord
  CREADTED_PLAYLISTS_ACHIEVEMENTS_COUNT = [5, 10, 25, 50, 100].freeze

  belongs_to :user, class_name: 'User'

  validates :actual_count, presence: true
  validates :achievement_type, presence: true

  enum achievement_type: { created_playlists: 0 }, _suffix: true
end
