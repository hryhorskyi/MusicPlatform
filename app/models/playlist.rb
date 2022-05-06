# frozen_string_literal: true

class Playlist < ApplicationRecord
  DESCRIPTION_MAX_LENGTH = 255
  NAME_LENGTH_RANGE = (2..80)

  belongs_to :owner, class_name: 'User', inverse_of: :owned_playlists

  has_many :comments, dependent: :destroy
  has_many :user_reactions, dependent: :destroy
  has_many :playlist_songs, dependent: :destroy
  has_many :songs, through: :playlist_songs

  validates :name, presence: true, uniqueness: { scope: :owner_id }, length: { in: NAME_LENGTH_RANGE }
  validates :description, length: { maximum: DESCRIPTION_MAX_LENGTH }
  validates :playlist_type, presence: true

  enum playlist_type: { private: 0, shared: 1, public: 2 }, _suffix: true
end
