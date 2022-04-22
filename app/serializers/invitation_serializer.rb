# frozen_string_literal: true

class InvitationSerializer < BaseSerializer
  belongs_to :requestor, serializer: PublicUserSerializer
  belongs_to :receiver, serializer: PublicUserSerializer

  attributes :status

  attribute :created_at do |object|
    object.created_at.strftime(DATE_TIME_FORMAT)
  end
end
