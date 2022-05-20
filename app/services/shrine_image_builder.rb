# frozen_string_literal: true

class ShrineImageBuilder
  def self.call(image:, filename:)
    Shrine.data_uri("data:image/jpg;base64,#{image}", filename: filename)
  end
end
