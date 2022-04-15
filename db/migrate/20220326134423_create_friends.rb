# frozen_string_literal: true

class CreateFriends < ActiveRecord::Migration[7.0]
  def change
    create_table :friends, id: :uuid do |t|
      t.belongs_to :initiator, foreign_key: { to_table: :users }, type: :uuid
      t.belongs_to :acceptor, foreign_key: { to_table: :users }, type: :uuid

      t.timestamps
    end

    add_index :friends, %i[initiator_id acceptor_id], unique: true
  end
end
