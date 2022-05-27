# frozen_string_literal: true

RSpec.describe AchievementMailer, type: :mailer do
  describe '#playlist' do
    let(:user) { create(:user) }
    let(:achievement_playlists_count) { Achievement::CREADTED_PLAYLISTS_ACHIEVEMENTS_COUNT.sample }
    let(:mail) do
      described_class.with(current_user_id: user.id,
                           playlist_actual_count: achievement_playlists_count).playlist.deliver_now
    end

    it 'renders the subject' do
      expected_message = I18n.t('mailer.achievement.subject')
      expect(mail.subject).to eq(expected_message)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'sends an email' do
      expect { mail }.to change { ActionMailer::Base.deliveries.count }.from(0).to(1)
    end
  end
end
