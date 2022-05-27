# frozen_string_literal: true

class AchievementMailer < ApplicationMailer
  def playlist
    @user = User.find_by(id: params[:current_user_id])
    @playlists_count = params[:playlist_actual_count]
    mail(
      template_path: 'mailers/achievements',
      template_name: 'playlist',
      to: @user.email,
      subject: I18n.t('mailer.achievement.subject')
    )
  end
end
