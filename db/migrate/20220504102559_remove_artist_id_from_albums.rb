# frozen_string_literal: true

class RemoveArtistIdFromAlbums < ActiveRecord::Migration[7.0]
  def change
    safety_assured { remove_column :albums, :artist_id, :uuid }
  end
end
