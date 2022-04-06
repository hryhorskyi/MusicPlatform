# frozen_string_literal: true

class UserSerializer < BaseSerializer
  DEFAULT_AVATAR_URL = 'dummy_avatar_url.png'

  attributes :email, :nickname, :first_name, :last_name

  attribute :avatar do |object|
    object.avatar.presence || DEFAULT_AVATAR_URL
  end
end
