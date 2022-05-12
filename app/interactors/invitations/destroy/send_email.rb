# frozen_string_literal: true

module Invitations
  module Destroy
    class SendEmail < Common::BaseOrganizer
      def call
        InvitationMailer.with(invitation_id: context.model.id).destroy.deliver_later
      end
    end
  end
end
