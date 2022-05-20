# frozen_string_literal: true

class ChangeFieldNameAvatarInUsers < ActiveRecord::Migration[7.0]
  def change
    safety_assured { rename_column :users, :avatar, :avatar_data }
  end
end
