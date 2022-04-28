# frozen_string_literal: true

class CreatePageContents < ActiveRecord::Migration[7.0]
  def change
    create_table :page_contents, id: :uuid do |t|
      t.string :page_slug, null: false

      t.timestamps
    end

    add_index :page_contents, :page_slug, unique: true
  end
end
