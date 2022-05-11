# frozen_string_literal: true

module Comments
  module Create
    class Organizer < Common::BaseOrganizer
      organize Initialize,
               Common::Model::Initialize,
               FindPlaylist,
               BuildAttributes,
               Common::Model::AssignAttributes,
               Common::Model::Validate,
               Common::Policy::Check,
               Common::Model::Persist
    end
  end
end
