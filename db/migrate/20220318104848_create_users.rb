# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :nickname, null: false
      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :nickname, unique: true
  end
end
