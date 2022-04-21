# frozen_string_literal: true

module MyAccount
  module Update
    class Initialization < Common::BaseInteractor
      def call
        context.validator_class = MyAccount::UpdateForm
        context.params_for_validation = context.params.merge(user: context.current_user)
      end
    end
  end
end
