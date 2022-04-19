# frozen_string_literal: true

module Invitations
  module Destroy
    class SetRevokeStatus < Common::BaseInteractor
      def call
        context.model.revoked_status!
      end
    end
  end
end
