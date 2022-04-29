# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments, id: :uuid do |t|
      t.belongs_to :user, foreign_key: { to_table: :users }, type: :uuid, null: false
      t.text :text
      t.belongs_to :playlist, foreign_key: { to_table: :playlists }, type: :uuid, null: false

      t.timestamps
    end
  end
end
