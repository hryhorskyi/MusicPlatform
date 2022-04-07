# frozen_string_literal: true

class AddIndexUniqToAlbums < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_index :albums, %i[name artist_id], unique: true, algorithm: :concurrently
  end
end
