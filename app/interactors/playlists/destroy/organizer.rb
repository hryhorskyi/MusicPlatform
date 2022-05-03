# frozen_string_literal: true

module Playlists
  module Destroy
    class Organizer < Common::BaseOrganizer
      organize FindPlaylist,
               Common::Model::Delete
    end
  end
end
