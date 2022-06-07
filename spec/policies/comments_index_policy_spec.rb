# frozen_string_literal: true

RSpec.describe CommentsIndexPolicy, type: :policy do
  subject(:result) { described_class.new(user, playlist) }

  let(:user) { create(:user) }

  before do
    create(:comment, playlist_id: playlist.id)
  end

  context 'when success' do
    context 'when playlist is public' do
      let(:playlist) { create(:playlist, :public) }

      context 'when user is not given' do
        let(:user) { nil }

        it { is_expected.to permit(:index) }
      end

      context 'when user given' do
        it { is_expected.to permit(:index) }
      end
    end

    context 'when playlist is shared' do
      let(:playlist) { create(:playlist, :shared, owner: user) }

      context 'when user is owner' do
        it { is_expected.to permit(:index) }
      end

      context 'when user is friend of owner' do
        let(:playlist) { create(:playlist, :shared, owner: owner) }
        let(:owner) { create(:user) }

        before do
          create(:friend) { create(:friend, initiator: owner, acceptor: user) }
        end

        it { is_expected.to permit(:index) }
      end
    end
  end

  context 'when failure' do
    context 'when playlist is private' do
      let(:playlist) { create(:playlist, :private) }

      context 'when user is not given' do
        let(:user) { nil }

        it { is_expected.not_to permit(:index) }
      end

      context 'when user is owner of playlist' do
        let(:playlist) { create(:playlist, :private, owner: user) }

        it { is_expected.not_to permit(:index) }
      end

      context 'when user is not owner of playlist' do
        it { is_expected.not_to permit(:index) }
      end
    end

    context 'when playlist is shared' do
      let(:playlist) { create(:playlist, :shared, owner: owner) }
      let(:owner) { create(:user) }

      context 'when user is not given' do
        let(:user) { nil }

        it { is_expected.not_to permit(:index) }
      end

      context 'when user is not a friend of owner' do
        it { is_expected.not_to permit(:index) }
      end
    end
  end
end
