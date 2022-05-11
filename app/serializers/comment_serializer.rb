# frozen_string_literal: true

class CommentSerializer < BaseSerializer
  attributes :text

  belongs_to :user, serializer: PublicUserSerializer

  attribute :created_at do |object|
    object.created_at.strftime(DATE_TIME_FORMAT)
  end
end
