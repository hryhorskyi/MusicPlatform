# frozen_string_literal: true

module Friends
  module Destroy
    class Organizer < Common::BaseOrganizer
      organize FindFriendship,
               SetFriend,
               FindPlaylists,
               ReassignePlaylistsSongs,
               DeletePlaylistsSongs,
               DeletePlaylistsComments,
               Common::Model::Delete

      around do |interactor|
        ActiveRecord::Base.transaction do
          interactor.call
        rescue ActiveRecord::RecordInvalid
          context.model.errors.add(:friendship, I18n.t('friends.destroy.errors.delete_rollback'))
          context.fail!(error_status: :unprocessable_entity)
        end
      end
    end
  end
end
