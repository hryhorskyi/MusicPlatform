# frozen_string_literal: true

class Admin < ApplicationRecord
  include EmailValidations
  include PasswordValidations

  has_secure_password
end
