# frozen_string_literal: true

class RemoveInvalidIndexFromAlbums < ActiveRecord::Migration[7.0]
  def up
    remove_index(:albums, :name) if index_exists?(:albums, :name, name: 'index_albums_on_name')
  end

  def down
    add_index(:albums, :name, unique: true)
  end
end
