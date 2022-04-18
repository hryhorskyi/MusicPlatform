# frozen_string_literal: true

class CreateArtists < ActiveRecord::Migration[7.0]
  def change
    create_table :artists, id: :uuid do |t|
      t.string :name, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
