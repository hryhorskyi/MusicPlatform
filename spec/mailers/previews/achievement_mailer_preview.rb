# frozen_string_literal: true

class AchievementMailerPreview < ActionMailer::Preview
  def playlist
    AchievementMailer.with(
      current_user_id: User.first&.id,
      playlist_actual_count: Achievement::CREADTED_PLAYLISTS_ACHIEVEMENTS_COUNT.sample
    )
  end
end
