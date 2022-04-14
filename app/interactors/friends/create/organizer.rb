# frozen_string_literal: true

module Friends
  module Create
    class Organizer < Common::BaseOrganizer
      organize SetBaseModel,
               FindInvitation,
               SetInitiatorToBaseModel,
               CheckInvitationIsPending,
               UpdateInvitationStatusPersistFriend
    end
  end
end
