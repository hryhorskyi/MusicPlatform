# frozen_string_literal: true

RSpec.describe Friends::Destroy::ReassignePlaylistsSongs do
  describe '.call' do
    subject(:result) do
      described_class.call(current_user: current_user,
                           friend: friend,
                           params: params,
                           current_user_shared_playlists: current_user_shared_playlist,
                           friend_shared_playlists: friend_shared_playlist)
    end

    let(:friend) { create(:user) }
    let(:current_user) { create(:user) }

    let(:friendship) { create(:friend, initiator: friend, acceptor: current_user) }

    let(:current_user_shared_playlist) { create(:playlist, :shared, owner_id: current_user.id) }
    let(:friend_shared_playlist) { create(:playlist, :shared, owner_id: current_user.id) }

    before do
      create_list(:playlist_song, 5, playlist_id: current_user_shared_playlist.id, user_id: friend.id)
      create_list(:playlist_song, 5, playlist_id: friend_shared_playlist.id, user_id: current_user.id)
    end

    context 'when songs reassigne' do
      let(:params) { { keep_songs: 'true' } }

      it 'change user_id of playlist_songs to current_user.id' do
        expect { result }.to change {
                               current_user_shared_playlist.playlist_songs.pluck(:user_id).uniq
                             }.from([friend.id]).to([current_user.id])
      end

      it 'change user_id of playlist_songs to friend.id' do
        expect { result }.to change {
                               friend_shared_playlist.playlist_songs.pluck(:user_id).uniq
                             }.from([current_user.id]).to([friend.id])
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
