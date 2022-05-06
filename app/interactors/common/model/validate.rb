# frozen_string_literal: true

module Common
  module Model
    class Validate < Common::BaseInteractor
      def call
        context.fail! if context.model.invalid?
      end
    end
  end
end
