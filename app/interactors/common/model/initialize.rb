# frozen_string_literal: true

module Common
  module Model
    class Initialize < Common::BaseInteractor
      def call
        context.model = context.model_class.new
      end
    end
  end
end
