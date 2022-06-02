# frozen_string_literal: true

RSpec.describe Friends::Destroy::Organizer do
  describe '.call' do
    subject(:result) do
      described_class.call(current_user: current_user, params: params)
    end

    let(:current_user) { create(:user) }
    let(:friend) { create(:user) }
    let(:friendship) { create(:friend, initiator: current_user, acceptor: friend) }
    let(:playlist) { create(:playlist, :shared, owner_id: current_user.id) }
    let(:params) { { id: friendship.id, keep_songs: keep_songs, keep_comments: keep_comments } }
    let(:keep_songs) { '' }
    let(:keep_comments) { '' }
    let(:expected_interactors) do
      [
        Friends::Destroy::FindFriendship,
        Friends::Destroy::SetFriend,
        Friends::Destroy::FindPlaylists,
        Friends::Destroy::ReassignePlaylistsSongs,
        Friends::Destroy::DeletePlaylistsSongs,
        Friends::Destroy::DeletePlaylistsComments,
        Common::Model::Delete
      ]
    end

    it 'has correct interactors' do
      expect(described_class.organized).to eq(expected_interactors)
    end

    context 'when found frienship' do
      context 'when current_user is initiator' do
        let(:friendship) { create(:friend, initiator: current_user) }

        it 'has proper friendship' do
          expect(result.model).to eq(friendship)
        end

        it 'has successfull result' do
          expect(result).to be_success
        end
      end

      context 'when current_user is acceptor' do
        let(:friendship) { create(:friend, acceptor: current_user) }

        it 'has proper friendship' do
          expect(result.model).to eq(friendship)
        end

        it 'has successfull result' do
          expect(result).to be_success
        end
      end
    end

    context 'when friend is setted' do
      context 'when current_user is initiator' do
        let(:friendship) { create(:friend, initiator: current_user) }

        it 'returns a proper friend' do
          expect(result.friend).to eq(friendship.acceptor)
        end
      end

      context 'when current_user is acceptor' do
        let(:friendship) { create(:friend, acceptor: current_user) }

        it 'returns a proper friend' do
          expect(result.friend).to eq(friendship.initiator)
        end
      end
    end

    context 'when songs reassigne' do
      before { create_list(:playlist_song, 5, playlist_id: playlist.id, user_id: friend.id) }

      let(:keep_songs) { 'true' }

      it 'change count of songs where current_user is owner' do
        expect { result }.to change { current_user.playlist_songs.count }.by(5)
      end

      it 'has successfull result' do
        expect(result).to be_success
      end
    end

    context 'when songs deleted from playlist' do
      before { create_list(:playlist_song, 5, playlist_id: playlist.id, user_id: friend.id) }

      let(:keep_songs) { 'false' }

      it 'change count of songs from current user playlist' do
        expect { result }.to change { PlaylistSong.all.count }.by(-5)
      end

      it 'has successfull result' do
        expect(result).to be_success
      end
    end

    context 'when delete playlist comments' do
      before do
        create_list(:comment, 3, user: current_user, playlist: friend_shared_playlist)
        create_list(:comment, 3, user: friend, playlist: playlist)
      end

      let(:friend_shared_playlist) { create(:playlist, :shared, owner: friend) }

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
    end

    context 'when success friendship delete' do
      before { friendship }

      it 'returns change count friendship' do
        expect { result }.to change { Friend.count }.from(1).to(0)
      end
    end

    context 'when successfully transaction rollback' do
      before do
        create(:playlist, :shared, owner_id: current_user.id)
        create_list(:playlist_song, 5, playlist_id: playlist.id, user_id: friend.id)
        create_list(:comment, 3, user: current_user, playlist: current_user.owned_playlists.last)

        allow_any_instance_of(Friend).to receive(:destroy!).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'returns not delete friendship' do
        friendship
        expect { result }.not_to(change { Friend.count })
      end

      it "returns not delete friend's playlist_songs" do
        friendship
        expect { result }.not_to(change { PlaylistSong.count })
      end

      it "returns not delete friend's comments" do
        friendship
        expect { result }.not_to(change { Comment.count })
      end
    end
  end
end
