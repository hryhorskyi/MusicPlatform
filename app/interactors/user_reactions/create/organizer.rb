# frozen_string_literal: true

module UserReactions
  module Create
    class Organizer < Common::BaseOrganizer
      organize Initialization,
               Common::Model::Initialize,
               FindPlaylist,
               CheckExistingOfReaction,
               ValidateTypeOfReaction,
               BuildAttributes,
               Common::Model::AssignAttributes,
               Common::Policy::Check,
               Common::Model::Persist
    end
  end
end
