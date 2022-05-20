# frozen_string_literal: true

module MyAccount
  class UpdateForm < Common::BaseForm
    include AvatarUploader.attachment(:avatar)
    attr_accessor :nickname, :first_name, :last_name, :user, :avatar_data

    validates :nickname, length: { in: User::NICKNAME_LENGTH }, presence: true
    validates :first_name, length: { in: User::FIRST_NAME_LENGTH },
                           presence: true,
                           unless: -> { initial?(:first_name, first_name) }
    validates :last_name, length: { in: User::LAST_NAME_LENGTH },
                          presence: true,
                          unless: -> { initial?(:last_name, last_name) }

    validate :validate_attachment

    private

    def initial?(attr_name, attr_value)
      user[attr_name].nil? && attr_value.nil?
    end

    def validate_attachment
      return true if avatar_attacher.validate

      avatar_attacher.errors.each { |error| errors.add(:image, error) } && false
    end
  end
end
