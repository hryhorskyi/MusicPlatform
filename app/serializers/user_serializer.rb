# frozen_string_literal: true

class UserSerializer < BaseSerializer
  DEFAULT_BIG_AVATAR_URL = '/app/assets/images/default_avatar/default_big.png'

  attributes :email, :nickname, :first_name, :last_name

  attribute :avatar do |object|
    object&.avatar_url(:large) || DEFAULT_BIG_AVATAR_URL
  end

  attribute :shared_playlists_number do |_object|
    # TODO: Number of shared playlists logic
    rand(10)
  end

  attribute :created_at do |object|
    object.created_at.strftime(DATE_TIME_FORMAT)
  end
end
