# frozen_string_literal: true

class AddAccountFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      change_table :users, bulk: true do |t|
        t.string :first_name
        t.string :last_name
        t.string :avatar
      end
    end
  end
end
