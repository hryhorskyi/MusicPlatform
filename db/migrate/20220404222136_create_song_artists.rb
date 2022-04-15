# frozen_string_literal: true

class CreateSongArtists < ActiveRecord::Migration[7.0]
  def change
    create_table :song_artists, id: :uuid do |t|
      t.belongs_to :song, null: false, foreign_key: { to_table: :songs }, type: :uuid
      t.belongs_to :artist, null: false, foreign_key: { to_table: :artists }, type: :uuid

      t.timestamps
    end

    add_index :song_artists, %i[song_id artist_id], unique: true
  end
end
