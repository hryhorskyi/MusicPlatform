# frozen_string_literal: true

module MyAccount
  module Update
    class SetBaseModel < Common::BaseInteractor
      def call
        context.model = context.current_user
      end
    end
  end
end
