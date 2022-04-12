# frozen_string_literal: true

class FriendSerializer < BaseSerializer
  attributes :created_at

  belongs_to :initiator, serializer: UserSerializer
  belongs_to :acceptor, serializer: UserSerializer
end
