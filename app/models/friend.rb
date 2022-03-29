# frozen_string_literal: true

class Friend < ApplicationRecord
  belongs_to :initiator, class_name: 'User'
  belongs_to :acceptor, class_name: 'User'

  validates_comparison_of :initiator_id, other_than: :acceptor_id
end
