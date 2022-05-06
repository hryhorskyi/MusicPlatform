# frozen_string_literal: true

module Playlists
  module Create
    class ValidateParams < Common::BaseInteractor
      def call
        validate_playlist_type

        context.fail! if context.model.errors.present?
      end

      private

      def validate_playlist_type
        return true if context.params[:playlist_type].in? Playlist.playlist_types.keys

        context.model.errors.add(:playlist_type, I18n.t('playlist.create.errors.invalid_playlist_type'))
      end
    end
  end
end
