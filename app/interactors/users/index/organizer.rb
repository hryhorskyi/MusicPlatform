# frozen_string_literal: true

module Users
  module Index
    class Organizer < Common::BaseOrganizer
      organize SetUsers,
               FilterByFriends,
               FilterByEmail,
               FilterByUser,
               Common::Service::Pagination
    end
  end
end
