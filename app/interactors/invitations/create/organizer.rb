# frozen_string_literal: true

module Invitations
  module Create
    class Organizer < Common::BaseOrganizer
      organize SetBaseModel,
               CheckReceiverEqualCurrentUser,
               FindReceiver,
               FindExistingInvitation,
               CheckExistingInvitationIsPending,
               CheckExistingFriendship,
               CheckRecentlyDeclined,
               Common::Model::Persist
    end
  end
end
