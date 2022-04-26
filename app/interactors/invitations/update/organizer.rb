# frozen_string_literal: true

module Invitations
  module Update
    class Organizer < Common::BaseOrganizer
      organize FindInvitation,
               SetDeclinedStatus,
               Common::Model::Persist
    end
  end
end
