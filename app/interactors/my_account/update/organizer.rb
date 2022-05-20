# frozen_string_literal: true

module MyAccount
  module Update
    class Organizer < Common::BaseOrganizer
      organize Initialization,
               SetBaseModel,
               BuildAvatarAttributes,
               Common::Model::ValidateParams,
               ValidateNicknameUniqueness,
               Common::Model::AssignAttributes,
               Common::Model::ImageDerivatives,
               Common::Model::Persist
    end
  end
end
