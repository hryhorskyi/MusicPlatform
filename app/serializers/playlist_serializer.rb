# frozen_string_literal: true

class PlaylistSerializer < BaseSerializer
  DEFAULT_LOGO_URL = 'dummy_logo_url.png'

  belongs_to :owner, serializer: UserSerializer

  has_many :songs
  has_many :comments

  attributes :name, :description

  attribute :likes_count do |object|
    object.user_reactions.like_reaction.count
  end

  attribute :unlikes_count do |object|
    object.user_reactions.unlike_reaction.count
  end

  attribute :logo do |object|
    object.logo.presence || DEFAULT_LOGO_URL
  end

  attribute :created_at do |object|
    object.created_at.strftime(DATE_TIME_FORMAT)
  end

  attribute :updated_at do |object|
    object.updated_at.strftime(DATE_TIME_FORMAT)
  end
end
