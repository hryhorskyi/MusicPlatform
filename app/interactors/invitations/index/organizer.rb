# frozen_string_literal: true

module Invitations
  module Index
    class Organizer < Common::BaseOrganizer
      organize FilterByRequestor,
               FilterByReceiver,
               AllInvitations
    end
  end
end
