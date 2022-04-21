# frozen_string_literal: true

module Users
  module Create
    class SetBaseModel < Common::BaseInteractor
      def call
        context.model = User.new(context.params)
      end
    end
  end
end
