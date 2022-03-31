# frozen_string_literal: true

class Invitation < ApplicationRecord
  belongs_to :requestor, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validates_comparison_of :requestor_id, other_than: :receiver_id
  validates :status, presence: true

  enum status: { pending: 0, declined: 1, accepted: 2 }
end
