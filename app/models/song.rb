# frozen_string_literal: true

class Song < ApplicationRecord
  belongs_to :album
  has_many :song_artists, dependent: :destroy
  has_many :artists, through: :song_artists
  has_many :song_genres, dependent: :destroy
  has_many :genres, through: :song_genres

  validates :name, presence: true, uniqueness: { scope: :album_id }
  validates :featured, inclusion: { in: [true, false] }
end
