# frozen_string_literal: true

class AddDeviseToAdmins < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    safety_assured do
      rename_column :admins, :password_digest, :encrypted_password
    end
  end
end
