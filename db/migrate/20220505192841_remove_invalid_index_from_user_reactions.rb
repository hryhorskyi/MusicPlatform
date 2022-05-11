# frozen_string_literal: true

class RemoveInvalidIndexFromUserReactions < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    remove_index :user_reactions, %i[user_id reaction], unique: true
    add_index :user_reactions, %i[user_id playlist_id], unique: true, algorithm: :concurrently
  end
end
