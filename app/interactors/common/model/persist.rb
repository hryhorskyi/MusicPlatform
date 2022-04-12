# frozen_string_literal: true

module Common
  module Model
    class Persist < Common::BaseInteractor
      def call
        context.model.save!
      end
    end
  end
end
