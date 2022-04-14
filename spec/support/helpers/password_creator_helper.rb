# frozen_string_literal: true

module Support
  module Helpers
    class PasswordCreatorHelper
      DEFAULT_LENGTH_CHARACTERS = 20

      class << self
        def call
          (lower_characters + upper_characters + special_characters + numbers).chars.shuffle.join
        end

        private

        def lower_characters
          FFaker::Lorem.characters(DEFAULT_LENGTH_CHARACTERS).downcase
        end

        def upper_characters
          FFaker::Lorem.characters(DEFAULT_LENGTH_CHARACTERS).upcase
        end

        def special_characters
          %w[@ $ ! % * ? &].sample
        end

        def numbers
          rand(100).to_s
        end
      end
    end
  end
end
