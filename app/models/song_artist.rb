# frozen_string_literal: true

class SongArtist < ApplicationRecord
  belongs_to :song
  belongs_to :artist

  validates :song_id, uniqueness: { scope: :artist_id }
end
