# frozen_string_literal: true

class Admin < ApplicationRecord
  devise :database_authenticatable

  include EmailValidations
  include PasswordValidations
end
