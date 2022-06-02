# frozen_string_literal: true

RSpec.describe Friends::Destroy::FindPlaylists do
  describe '.call' do
    subject(:result) { described_class.call(current_user: current_user, friend: friend) }

    let(:current_user) { create(:user) }
    let(:friend) { create(:user) }
    let(:current_user_shared_playlists) { create_list(:playlist, 3, :shared, owner: current_user) }
    let(:friend_shared_playlists) { create_list(:playlist, 3, :shared, owner: friend) }

    context 'when playlist assign correctly' do
      it 'returns correct playlists for current_user' do
        expect(result.current_user_shared_playlists).to eq(current_user_shared_playlists)
      end

      it 'returns correct playlists for friend' do
        expect(result.friend_shared_playlists).to eq(friend_shared_playlists)
      end
    end

    it 'has success result' do
      expect(result).to be_success
    end
  end
end
