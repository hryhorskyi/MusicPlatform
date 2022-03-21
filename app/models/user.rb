# frozen_string_literal: true

class User < ApplicationRecord
  NICKNAME_LENGTH = (3..20)
  PASSWORD_REGEXP = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}\z/
  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :nickname, presence: true, uniqueness: true, length: { minimum: NICKNAME_LENGTH.min,
                                                                   maximum: NICKNAME_LENGTH.max }
  validates :password, presence: true, format: { with: PASSWORD_REGEXP }
end
