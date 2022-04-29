# frozen_string_literal: true

class PlaylistSong < ApplicationRecord
  belongs_to :user
  belongs_to :song
  belongs_to :playlist

  validates :song, uniqueness: { scope: :playlist_id }
end
