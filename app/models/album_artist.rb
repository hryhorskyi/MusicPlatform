# frozen_string_literal: true

class AlbumArtist < ApplicationRecord
  belongs_to :album
  belongs_to :artist

  validates :album, uniqueness: { scope: :artist_id }
end
