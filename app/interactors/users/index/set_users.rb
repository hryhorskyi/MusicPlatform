# frozen_string_literal: true

module Users
  module Index
    class SetUsers < Common::BaseInteractor
      def call
        context.collection = User.all
      end
    end
  end
end
