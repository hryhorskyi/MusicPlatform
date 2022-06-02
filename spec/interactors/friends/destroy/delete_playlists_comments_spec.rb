# frozen_string_literal: true

RSpec.describe Friends::Destroy::DeletePlaylistsComments do
  describe '.call' do
    subject(:result) do
      described_class.call(params: { keep_comments: keep_comments },
                           current_user: current_user,
                           friend: friend,
                           friend_shared_playlists: friend_shared_playlist,
                           current_user_shared_playlists: current_user_shared_playlist)
    end

    before do
      create_list(:comment, 3, user: current_user, playlist: friend_shared_playlist)
      create_list(:comment, 3, user: friend, playlist: current_user_shared_playlist)
    end

    let(:current_user) { create(:user) }
    let(:friend) { create(:user) }

    let(:friend_shared_playlist) { create(:playlist, :shared, owner: friend) }
    let(:current_user_shared_playlist) { create(:playlist, :shared, owner: current_user) }

    context 'when provided param keep_comments to equal true' do
      let(:keep_comments) { 'true' }

      it 'returns not change count of comments for current user' do
        expect { result }.not_to(change { current_user.comments.count })
      end

      it 'returns not change count of comments for friend' do
        expect { result }.not_to(change { friend.comments.count })
      end
    end

    context 'when provided param keep_comments to equal false' do
      let(:keep_comments) { 'false' }

      it 'returns change count of comments for current user' do
        expect { result }.to change { current_user.comments.count }.by(-3)
      end

      it 'returns change count of comments for friend' do
        expect { result }.to change { friend.comments.count }.by(-3)
      end
    end

    context 'when provided param keep_comments to equal incorrect value' do
      let(:keep_comments) { 'abra-kada-bra' }

      it 'returns change count of comments for current user' do
        expect { result }.to change { current_user.comments.count }.by(-3)
      end

      it 'returns change count of comments for friend' do
        expect { result }.to change { friend.comments.count }.by(-3)
      end
    end
  end
end
