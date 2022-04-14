# frozen_string_literal: true

module Friends
  module Create
    class SetBaseModel < Common::BaseInteractor
      def call
        context.model = Friend.new(acceptor: context.current_user)
      end
    end
  end
end
