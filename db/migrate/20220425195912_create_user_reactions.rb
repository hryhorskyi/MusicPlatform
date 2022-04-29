# frozen_string_literal: true

class CreateUserReactions < ActiveRecord::Migration[7.0]
  def change
    create_table :user_reactions, id: :uuid do |t|
      t.belongs_to :user, foreign_key: { to_table: :users }, type: :uuid, null: false
      t.belongs_to :playlist, foreign_key: { to_table: :playlists }, type: :uuid, null: false
      t.integer :reaction

      t.timestamps
    end

    add_index :user_reactions, %i[user_id reaction], unique: true
  end
end
