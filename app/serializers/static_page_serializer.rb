# frozen_string_literal: true

class StaticPageSerializer < BaseSerializer
  attributes :page_slug

  attribute :content do |object|
    object.content.body
  end
end
