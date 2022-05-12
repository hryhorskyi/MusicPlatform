# frozen_string_literal: true

module Invitations
  module Create
    class SendEmail < Common::BaseInteractor
      def call
        InvitationMailer.with(invitation_id: context.model.id).create.deliver_later
      end
    end
  end
end
