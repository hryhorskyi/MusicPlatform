# frozen_string_literal: true

class CreateSongArtists < ActiveRecord::Migration[7.0]
  def change
    create_table :song_artists do |t|
      t.belongs_to :song, null: false, foreign_key: { to_table: :songs }
      t.belongs_to :artist, null: false, foreign_key: { to_table: :artists }

      t.timestamps
    end

    add_index :song_artists, %i[song_id artist_id], unique: true
  end
end
