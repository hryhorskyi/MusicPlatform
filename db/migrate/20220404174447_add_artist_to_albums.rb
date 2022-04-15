# frozen_string_literal: true

class AddArtistToAlbums < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_reference :albums, :artist, index: { algorithm: :concurrently }, type: :uuid
  end
end
