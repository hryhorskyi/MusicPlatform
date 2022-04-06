# frozen_string_literal: true

class Artist < ApplicationRecord
  has_many :song_artists, dependent: :destroy
  has_many :songs, through: :song_artists

  validates :name, presence: true, uniqueness: true
end
