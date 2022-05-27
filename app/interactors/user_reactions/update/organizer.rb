# frozen_string_literal: true

module UserReactions
  module Update
    class Organizer < Common::BaseOrganizer
      organize Initialization,
               Common::Model::Initialize,
               FindPlaylist,
               FindUserReaction,
               ValidateTypeOfReaction,
               CheckChangingOfReaction,
               Common::Model::AssignAttributes,
               Common::Policy::Check,
               Common::Model::Persist
    end
  end
end
