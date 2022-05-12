# frozen_string_literal: true

module Invitations
  module Destroy
    class Organizer < Common::BaseOrganizer
      organize FindInvitation,
               SetRevokeStatus,
               SendEmail
    end
  end
end
