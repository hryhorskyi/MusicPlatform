# frozen_string_literal: true

module MyAccount
  class UpdateForm < Common::BaseForm
    attr_accessor :nickname, :first_name, :last_name, :user

    validates :nickname, length: { in: User::NICKNAME_LENGTH }, presence: true
    validates :first_name, length: { in: User::FIRST_NAME_LENGTH },
                           presence: true,
                           unless: -> { initial?(:first_name, first_name) }
    validates :last_name, length: { in: User::LAST_NAME_LENGTH },
                          presence: true,
                          unless: -> { initial?(:last_name, last_name) }

    private

    def initial?(attr_name, attr_value)
      user[attr_name].nil? && attr_value.nil?
    end
  end
end
