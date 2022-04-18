# frozen_string_literal: true

class CreateSongs < ActiveRecord::Migration[7.0]
  def change
    create_table :songs, id: :uuid do |t|
      t.string :name, null: false
      t.boolean :featured, default: false, null: false
      t.belongs_to :album, foreign_key: { to_table: :albums }, type: :uuid

      t.timestamps
    end

    add_index :songs, %i[name album_id], unique: true
  end
end
