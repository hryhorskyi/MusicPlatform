# frozen_string_literal: true

module Common
  module Model
    class ImageDerivatives < Common::BaseInteractor
      def call
        context.model.avatar_derivatives! if context.model.avatar
      end
    end
  end
end
