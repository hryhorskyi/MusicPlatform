# frozen_string_literal: true

module Invitations
  module Destroy
    class Organizer < Common::BaseOrganizer
      organize FindInvitation,
               SetRevokeStatus
    end
  end
end
