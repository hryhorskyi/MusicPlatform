# frozen_string_literal: true

RSpec.describe Playlists::Destroy::FindPlaylist do
  describe '.call' do
    subject(:result) { described_class.call(current_user: current_user, params: { id: playlist_id }) }

    context 'when a playlist is found successfully' do
      let(:searchable_playlist) { create(:playlist, owner: current_user) }
      let(:playlist_id) { searchable_playlist.id }
      let(:current_user) { create(:user) }

      it 'returns playlist_id of current_user for destroy' do
        expect(result.model).to eq(searchable_playlist)
      end
    end

    context 'when a playlist is not found' do
      let(:current_user) { create(:user) }

      context 'when user has not the playlist' do
        let(:playlist_id) { create(:playlist).id }

        it 'returns nil' do
          expect(result.model).to be_nil
        end
      end

      context 'when provided incorrect playlist_id' do
        let(:playlist_id) { SecureRandom.uuid }

        it 'returns nil in context model' do
          expect(result.model).to be_nil
        end
      end
    end
  end
end
