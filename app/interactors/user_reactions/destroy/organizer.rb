# frozen_string_literal: true

module UserReactions
  module Destroy
    class Organizer < Common::BaseOrganizer
      organize Initialization,
               FindPlaylist,
               FindReaction,
               Common::Policy::Check,
               Common::Model::Delete
    end
  end
end
