# frozen_string_literal: true

module Comments
  module Index
    class Organizer < Common::BaseOrganizer
      organize Initialize,
               FindPlaylist,
               Common::Policy::Check,
               SetComments,
               Common::Service::Pagination
    end
  end
end
