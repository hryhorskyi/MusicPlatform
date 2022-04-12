# frozen_string_literal: true

class InvitationSerializer < BaseSerializer
  belongs_to :requestor, serializer: UserSerializer
  belongs_to :receiver, serializer: UserSerializer

  attributes :id, :status, :created_at
end
