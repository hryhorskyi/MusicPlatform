# frozen_string_literal: true

RSpec.describe PlaylistSongs::Create::Organizer do
  describe '.call' do
    subject(:result) { described_class.call(current_user: user, params: params) }

    let(:user) { create(:user) }
    let(:playlist) { create(:playlist, :public, owner_id: user.id) }
    let(:params) { { playlist_id: playlist.id, song_id: song.id } }
    let(:song) { create(:song) }
    let(:expected_interactors) do
      [
        PlaylistSongs::Create::Initialize,
        Common::Model::Initialize,
        PlaylistSongs::Create::FindPlaylist,
        PlaylistSongs::Create::FindSong,
        PlaylistSongs::Create::BuildAttributes,
        Common::Model::AssignAttributes,
        Common::Policy::Check,
        Common::Model::Validate,
        Common::Model::Persist
      ]
    end

    it 'has correct interactors' do
      expect(described_class.organized).to eq(expected_interactors)
    end

    context 'when song successfully added' do
      it 'has successful result' do
        expect(result).to be_success
      end

      it 'persisted song to playlist' do
        expect { result }.to change { playlist.songs.count }.from(0).to(1)
      end
    end

    context 'when song already exist in playlist' do
      before { create(:playlist_song, playlist_id: playlist.id, song_id: song.id) }

      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has correct error message' do
        expected_message = I18n.t('errors.messages.taken')

        expect(result.model.errors.messages[:song].first).to eq(expected_message)
      end
    end

    context 'when song id incorrect' do
      let(:params) { { playlist_id: playlist.id, song_id: 'incorrect id' } }

      it 'has failure result' do
        expect(result).to be_failure
      end
    end
  end
end
