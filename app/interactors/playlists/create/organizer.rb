# frozen_string_literal: true

module Playlists
  module Create
    class Organizer < Common::BaseOrganizer
      organize Initialize,
               Common::Model::Initialize,
               ValidateParams,
               BuildAttributes,
               Common::Model::AssignAttributes,
               Common::Model::Validate,
               Common::Model::Persist,
               ProcessAchievement
    end
  end
end
