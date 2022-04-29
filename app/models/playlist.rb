# frozen_string_literal: true

class Playlist < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :user_reactions, dependent: :destroy
  has_many :playlist_songs, dependent: :destroy
  has_many :songs, through: :playlist_songs
  belongs_to :owner, class_name: 'User', inverse_of: :owned_playlists

  validates :name, presence: true, uniqueness: { scope: :owner_id }
  validates :playlist_type, presence: true

  enum playlist_type: { private: 0, shared: 1, public: 2 }, _suffix: true
end
