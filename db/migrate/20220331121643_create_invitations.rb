# frozen_string_literal: true

class CreateInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :invitations, id: :uuid do |t|
      t.belongs_to :requestor, foreign_key: { to_table: :users }, type: :uuid
      t.belongs_to :receiver, foreign_key: { to_table: :users }, type: :uuid
      t.integer :status, default: 0, null: false
      t.datetime :declined_at

      t.timestamps
    end
  end
end
