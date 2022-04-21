# frozen_string_literal: true

class Admin < ApplicationRecord
  devise :database_authenticatable

  validates :email, uniqueness: true

  include EmailValidations
  include PasswordValidations
end
