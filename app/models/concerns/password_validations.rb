# frozen_string_literal: true

module PasswordValidations
  extend ActiveSupport::Concern

  PASSWORD_REGEXP = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}\z/

  included do
    validates :password,
              presence: true,
              confirmation: true,
              format: { with: PASSWORD_REGEXP }
  end
end
