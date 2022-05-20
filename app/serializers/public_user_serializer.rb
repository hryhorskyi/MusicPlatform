# frozen_string_literal: true

class PublicUserSerializer < BaseSerializer
  set_type :user
  attributes :nickname

  attribute :avatar do |object|
    object&.avatar_url(:large) || UserSerializer::DEFAULT_BIG_AVATAR_URL
  end
end
