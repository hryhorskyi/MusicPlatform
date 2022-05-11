# frozen_string_literal: true

class Comment < ApplicationRecord
  TEXT_LENGTH = (10..500)

  belongs_to :user
  belongs_to :playlist

  validates :text, presence: true, length: { in: TEXT_LENGTH }
end
