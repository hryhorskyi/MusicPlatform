# frozen_string_literal: true

class PageContent < ApplicationRecord
  has_rich_text :content

  validates :page_slug, presence: true, uniqueness: true
end
