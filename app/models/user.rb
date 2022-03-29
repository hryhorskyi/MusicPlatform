# frozen_string_literal: true

class User < ApplicationRecord
  include EmailValidations
  include PasswordValidations

  has_many :friends, dependent: :destroy

  NICKNAME_LENGTH = (3..20)
  has_secure_password

  validates :nickname, presence: true, uniqueness: true, length: { minimum: NICKNAME_LENGTH.min,
                                                                   maximum: NICKNAME_LENGTH.max }
end
