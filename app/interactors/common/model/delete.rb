# frozen_string_literal: true

module Common
  module Model
    class Delete < Common::BaseInteractor
      def call
        context.model.destroy!
      end
    end
  end
end
