# frozen_string_literal: true

class CreateAlbumArtists < ActiveRecord::Migration[7.0]
  def change
    create_table :album_artists, id: :uuid do |t|
      t.belongs_to :album, null: false, foreign_key: { to_table: :albums }, type: :uuid
      t.belongs_to :artist, null: false, foreign_key: { to_table: :artists }, type: :uuid

      t.timestamps
    end

    add_index :album_artists, %i[album_id artist_id], unique: true
  end
end
