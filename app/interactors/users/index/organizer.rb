# frozen_string_literal: true

module Users
  module Index
    class Organizer < Common::BaseOrganizer
      organize SetUsers,
               FilterByFriends,
               FilterByUser
    end
  end
end
