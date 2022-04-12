# frozen_string_literal: true

class Invitation < ApplicationRecord
  DECLINED_AT_EXPIRATION_TIME = 1.day

  belongs_to :requestor, class_name: 'User', inverse_of: :invitations
  belongs_to :receiver, class_name: 'User', inverse_of: :invitations

  validates_comparison_of :requestor_id, other_than: :receiver_id
  validates :status, presence: true

  enum status: { pending: 0, declined: 1, accepted: 2 }, _suffix: true
end
