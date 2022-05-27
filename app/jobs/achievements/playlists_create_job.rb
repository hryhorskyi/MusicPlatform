# frozen_string_literal: true

module Achievements
  class PlaylistsCreateJob < ApplicationJob
    def perform(current_user_id)
      @current_user_id = current_user_id
      return if !enough_playlists_for_achievement? || achievement_exist?

      send_email if create_achievement
    end

    private

    def create_achievement
      Achievement.create(user_id: @current_user_id, actual_count: playlists_count,
                         achievement_type: 'created_playlists')
    end

    def send_email
      AchievementMailer.with(current_user_id: @current_user_id,
                             playlist_actual_count: playlists_count).playlist.deliver_now
    end

    def playlists_count
      @playlists_count ||= Playlist.where(owner_id: @current_user_id).count
    end

    def achievement_exist?
      Achievement.exists?(user_id: @current_user_id, actual_count: playlists_count)
    end

    def enough_playlists_for_achievement?
      Achievement::CREADTED_PLAYLISTS_ACHIEVEMENTS_COUNT.include?(playlists_count)
    end
  end
end
