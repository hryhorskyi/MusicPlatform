# frozen_string_literal: true

class Friend < ApplicationRecord
  belongs_to :initiator, class_name: 'User', inverse_of: :initiated_friendships
  belongs_to :acceptor, class_name: 'User', inverse_of: :accepted_friendships

  validates_comparison_of :initiator_id, other_than: :acceptor_id
end
