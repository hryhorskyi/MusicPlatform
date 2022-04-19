# frozen_string_literal: true

class Invitation < ApplicationRecord
  DECLINED_AT_EXPIRATION_TIME = 1.day

  belongs_to :requestor, class_name: 'User', inverse_of: :sent_invitations
  belongs_to :receiver, class_name: 'User', inverse_of: :received_invitations

  validates_comparison_of :requestor_id, other_than: :receiver_id
  validates :status, presence: true

  enum status: { pending: 0, declined: 1, accepted: 2, revoked: 3 }, _suffix: true
end
