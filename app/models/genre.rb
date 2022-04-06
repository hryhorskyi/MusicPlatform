# frozen_string_literal: true

class Genre < ApplicationRecord
  has_many :song_genres, dependent: :destroy
  has_many :songs, through: :song_genres

  validates :name, presence: true, uniqueness: true
end
