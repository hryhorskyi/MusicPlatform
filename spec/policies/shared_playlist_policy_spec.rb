# frozen_string_literal: true

RSpec.describe SharedPlaylistPolicy, type: :policy do
  subject(:result) { described_class.new(user, playlist) }

  let(:user) { create(:user) }
  let(:playlist) { create(:playlist, :shared) }

  context 'when user is initiator of friendship with playlist owner' do
    before do
      create(:friend, initiator: user, acceptor: playlist.owner)
    end

    it { is_expected.to permit(:read) }
  end

  context 'when user is acceptor friendship with playlist owner' do
    before do
      create(:friend, initiator: playlist.owner, acceptor: user)
    end

    it { is_expected.to permit(:read) }
  end

  context 'when user is not friend of playlist owner' do
    it { is_expected.not_to permit(:read) }
  end
end
