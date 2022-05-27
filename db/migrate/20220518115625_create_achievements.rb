# frozen_string_literal: true

class CreateAchievements < ActiveRecord::Migration[7.0]
  def change
    create_table :achievements, id: :uuid do |t|
      t.integer :achievement_type, null: false
      t.integer :actual_count, null: false
      t.belongs_to :user, foreign_key: { to_table: :users }, type: :uuid, null: false

      t.timestamps
    end
  end
end
