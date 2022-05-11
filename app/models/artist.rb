# frozen_string_literal: true

class Artist < ApplicationRecord
  has_many :album_artists, dependent: :destroy
  has_many :albums, through: :album_artists
  has_many :song_artists, dependent: :destroy
  has_many :songs, through: :song_artists

  validates :name, presence: true, uniqueness: true
end
