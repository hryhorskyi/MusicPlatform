# frozen_string_literal: true

class SongSerializer < BaseSerializer
  belongs_to :album
  attributes :name, :featured
end
