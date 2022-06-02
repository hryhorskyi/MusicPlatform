# frozen_string_literal: true

RSpec.describe Friends::Destroy::DeletePlaylistsSongs do
  describe '.call' do
    subject(:result) do
      described_class.call(params: params,
                           current_user: current_user,
                           friend: friend,
                           friend_shared_playlists: friend_shared_playlist,
                           current_user_shared_playlists: current_user_shared_playlist)
    end

    before do
      create_list(:playlist_song, 5, playlist_id: current_user_shared_playlist.id, user_id: friend.id)
      create_list(:playlist_song, 5, playlist_id: friend_shared_playlist.id, user_id: current_user.id)
    end

    let(:friend) { create(:user) }
    let(:current_user) { create(:user) }

    let(:friendship) { create(:friend, initiator: friend, acceptor: current_user) }

    let(:current_user_shared_playlist) { create(:playlist, :shared, owner_id: current_user.id) }
    let(:friend_shared_playlist) { create(:playlist, :shared, owner_id: friend.id) }

    context 'when songs deleted from playlist' do
      let(:params) { { keep_songs: 'false' } }

      it 'change count of songs from current user playlist' do
        expect { result }.to change { current_user_shared_playlist.playlist_songs.count }.by(-5)
      end

      it 'change count of songs from friend playlist' do
        expect { result }.to change { friend_shared_playlist.playlist_songs.count }.by(-5)
      end

      it 'has successfull result' do
        expect(result).to be_success
      end
    end

    context 'when pass incorrect params' do
      let(:params) { { keep_songs: 'blablablab' } }

      it 'has successfull result' do
        expect(result).to be_success
      end
    end
  end
end
