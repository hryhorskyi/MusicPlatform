# frozen_string_literal: true

class CreateSongGenres < ActiveRecord::Migration[7.0]
  def change
    create_table :song_genres, id: :uuid do |t|
      t.belongs_to :song, null: false, foreign_key: { to_table: :songs }, type: :uuid
      t.belongs_to :genre, null: false, foreign_key: { to_table: :genres }, type: :uuid

      t.timestamps
    end

    add_index :song_genres, %i[song_id genre_id], unique: true
  end
end
