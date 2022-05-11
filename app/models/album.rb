# frozen_string_literal: true

class Album < ApplicationRecord
  has_many :songs, dependent: :destroy
  has_many :album_artists, dependent: :destroy
  has_many :artists, through: :album_artists

  validates :name, presence: true

  validate :name_uniqueness_in_artists_scope

  private

  def name_uniqueness_in_artists_scope
    return unless DublicatedAlbumNameOnArtistsScopeQuery.new.call({ album_name: name, artists: artists,
                                                                    excluded_ids: [id] }).exists?

    errors.add(:name, I18n.t('albums.create.errors.name.is_not_unique'))
  end
end
