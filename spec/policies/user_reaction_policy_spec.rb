# frozen_string_literal: true

RSpec.describe UserReactionPolicy, type: :policy do
  subject(:result) { described_class.new(user, user_reaction) }

  let(:user) { create(:user) }
  let(:user_reaction) { create(:user_reaction, playlist: playlist) }

  context 'when user is not playlist owner' do
    let(:playlist) { create(:playlist, :public) }

    it { is_expected.to permit(:create) }
  end

  context 'when user is playlist owner' do
    let(:playlist) { create(:playlist, owner: user) }

    it { is_expected.not_to permit(:create) }
  end

  context 'when playlist is shared' do
    let(:playlist) { create(:playlist, :shared) }

    it { is_expected.not_to permit(:create) }
  end

  context 'when playlist is private' do
    let(:playlist) { create(:playlist, :private) }

    it { is_expected.not_to permit(:create) }
  end

  context 'when user is friend of playlist owner and playlist is shared' do
    before do
      create(:friend, initiator: user, acceptor: playlist.owner)
    end

    let(:playlist) { create(:playlist, :shared) }

    it { is_expected.to permit(:create) }
  end

  context 'when user is friend of playlist owner and playlist is private' do
    before do
      create(:friend, initiator: user, acceptor: playlist.owner)
    end

    let(:playlist) { create(:playlist, :private) }

    it { is_expected.not_to permit(:create) }
  end
end
