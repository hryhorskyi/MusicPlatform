# frozen_string_literal: true

class Album < ApplicationRecord
  validates :name, presence: true
end
