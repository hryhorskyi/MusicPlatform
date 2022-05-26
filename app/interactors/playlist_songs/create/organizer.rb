# frozen_string_literal: true

module PlaylistSongs
  module Create
    class Organizer < Common::BaseOrganizer
      organize Initialize,
               Common::Model::Initialize,
               FindPlaylist,
               FindSong,
               BuildAttributes,
               Common::Model::AssignAttributes,
               Common::Policy::Check,
               Common::Model::Validate,
               Common::Model::Persist
    end
  end
end
