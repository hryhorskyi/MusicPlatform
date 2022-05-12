# frozen_string_literal: true

module Invitations
  module Update
    class SendEmail < Common::BaseOrganizer
      def call
        InvitationMailer.with(invitation_id: context.model.id).update.deliver_later
      end
    end
  end
end
