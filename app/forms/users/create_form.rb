# frozen_string_literal: true

module Users
  class CreateForm < Common::BaseForm
    include EmailValidations
    include PasswordValidations

    attr_accessor :email, :password, :password_confirmation, :nickname

    validates :nickname, presence: true, length: { in: User::NICKNAME_LENGTH }
    validate :email_validate_unique
    validate :nickname_validate_unique

    private

    def email_validate_unique
      errors.add(:email, I18n.t('users.create.errors.email_exist')) if User.exists?(email: email)
    end

    def nickname_validate_unique
      errors.add(:nickname, I18n.t('users.create.errors.nickname_exist')) if User.exists?(nickname: nickname)
    end
  end
end
