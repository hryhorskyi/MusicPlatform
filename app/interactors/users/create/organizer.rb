# frozen_string_literal: true

module Users
  module Create
    class Organizer < Common::BaseOrganizer
      organize Initialization,
               SetBaseModel,
               Common::Model::ValidateParams,
               Common::Model::Persist
    end
  end
end
