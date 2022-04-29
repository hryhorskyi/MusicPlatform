# frozen_string_literal: true

class CreatePlaylists < ActiveRecord::Migration[7.0]
  def change
    create_table :playlists, id: :uuid do |t|
      t.string :name, null: false
      t.text :description
      t.integer :playlist_type, null: false
      t.string :logo
      t.belongs_to :owner, foreign_key: { to_table: :users }, type: :uuid, null: false

      t.timestamps
    end

    add_index :playlists, %i[name owner_id], unique: true
  end
end
