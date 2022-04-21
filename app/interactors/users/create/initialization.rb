# frozen_string_literal: true

module Users
  module Create
    class Initialization < Common::BaseInteractor
      def call
        context.validator_class = Users::CreateForm
      end
    end
  end
end
