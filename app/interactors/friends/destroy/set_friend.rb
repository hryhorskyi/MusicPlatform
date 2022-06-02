# frozen_string_literal: true

module Friends
  module Destroy
    class SetFriend < Common::BaseInteractor
      def call
        context.friend = friend
      end

      private

      def friend
        context.model.acceptor == context.current_user ? context.model.initiator : context.model.acceptor
      end
    end
  end
end
