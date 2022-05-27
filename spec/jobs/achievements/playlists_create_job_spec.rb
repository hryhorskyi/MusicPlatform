# frozen_string_literal: true

RSpec.describe Achievements::PlaylistsCreateJob, type: :job do
  describe 'perform' do
    subject(:perform) { described_class.perform_now(current_user.id) }

    let(:current_user) { create(:user) }

    context 'when user has not enough created playlists' do
      it 'has not create achievement' do
        expect { perform }.not_to(change { Achievement.count })
      end

      it 'has not send email' do
        expect { perform }.not_to(change { ActionMailer::Base.deliveries.count })
      end
    end

    context 'when user has enough created playlists' do
      before { create_list(:playlist, 5, owner: current_user) }

      it 'has created achievement' do
        expect { perform }.to change { Achievement.count }.from(0).to(1)
      end

      it 'has sent email' do
        expect { perform }.to change { ActionMailer::Base.deliveries.count }.from(0).to(1)
      end
    end

    context 'when user has this achievement' do
      before do
        create(:achievement, user: current_user, actual_count: 5)
        create_list(:playlist, 5, owner: current_user)
      end

      it 'has not create achievement' do
        expect { perform }.not_to(change { Achievement.count })
      end

      it 'has not send email' do
        expect { perform }.not_to(change { ActionMailer::Base.deliveries.count })
      end
    end

    context 'when achievement has not created' do
      before do
        allow(Achievement).to receive(:create).and_return(false)
        create_list(:playlist, 5, owner: current_user)
      end

      it 'has not sent email' do
        expect { perform }.not_to(change { ActionMailer::Base.deliveries.count })
      end

      it 'has not create achievement' do
        expect { perform }.not_to(change { Achievement.count })
      end
    end
  end
end
