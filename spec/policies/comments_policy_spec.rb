# frozen_string_literal: true

RSpec.describe CommentsPolicy, type: :policy do
  subject(:result) { described_class.new(user, comment) }

  let(:user) { create(:user) }
  let(:comment) { create(:comment, playlist_id: playlist.id) }
  let(:playlist) { create(:playlist, :public) }

  context 'when playlist is public' do
    it { is_expected.to permit(:create) }
  end

  context 'when playlist is private' do
    let(:comment) { create(:comment, playlist_id: playlist.id) }
    let(:playlist) { create(:playlist, :private) }

    it { is_expected.not_to permit(:create) }
  end

  context 'when playlist is shared and user friendship with playlist owner' do
    let(:playlist) { create(:playlist, :shared) }

    before { create(:friend, initiator_id: user.id, acceptor_id: playlist.owner_id) }

    it { is_expected.to permit(:create) }
  end

  context 'when playlist is shared and user friendship not playlist owner' do
    let(:playlist) { create(:playlist, :shared) }
    let(:friend) { create(:user) }

    before { create(:friend, initiator_id: user.id, acceptor_id: friend.id) }

    it { is_expected.not_to permit(:create) }
  end

  context 'when playlist is shared and user playlist owner' do
    let(:playlist) { create(:playlist, :shared, owner: user) }

    it { is_expected.to permit(:create) }
  end

  context 'when playlist is shared' do
    let(:playlist) { create(:playlist, :shared) }

    it { is_expected.not_to permit(:create) }
  end

  context 'when a user has more than 3 comments and the last comments was written in less than 1 minute' do
    before { create_list(:comment, 3, playlist_id: playlist.id, user: user) }

    it { is_expected.not_to permit(:create) }
  end

  context 'when a user has more than 3 comments and the last comments was written in more than 1 minute' do
    before { create_list(:comment, 3, user: user, created_at: 2.minutes.ago) }

    it { is_expected.to permit(:create) }
  end
end
