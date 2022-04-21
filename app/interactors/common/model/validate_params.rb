# frozen_string_literal: true

module Common
  module Model
    class ValidateParams < Common::BaseInteractor
      def call
        return if form.valid?

        context.model.errors.copy!(form.errors)
        context.fail!
      end

      private

      def form
        @form ||= context.validator_class.new(context.params_for_validation || context.params)
      end
    end
  end
end
