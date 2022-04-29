# frozen_string_literal: true

class CreatePlaylistSongs < ActiveRecord::Migration[7.0]
  def change
    create_table :playlist_songs, id: :uuid do |t|
      t.belongs_to :song, foreign_key: { to_table: :songs }, type: :uuid, null: false
      t.belongs_to :user, foreign_key: { to_table: :users }, type: :uuid, null: false
      t.belongs_to :playlist, foreign_key: { to_table: :playlists }, type: :uuid, null: false

      t.timestamps
    end

    add_index :playlist_songs, %i[song_id playlist_id], unique: true
  end
end
