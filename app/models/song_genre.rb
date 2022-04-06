# frozen_string_literal: true

class SongGenre < ApplicationRecord
  belongs_to :song
  belongs_to :genre

  validates :song_id, uniqueness: { scope: :genre_id }
end
