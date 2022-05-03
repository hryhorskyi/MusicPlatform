# frozen_string_literal: true

RSpec.describe Playlists::Destroy::Organizer do
  describe '.call' do
    subject(:result) do
      described_class.call(current_user: current_user, params: { id: playlist_id })
    end

    let(:current_user) { create(:user) }
    let(:expected_interactors) do
      [
        Playlists::Destroy::FindPlaylist,
        Common::Model::Delete
      ]
    end

    it 'has correct interactors' do
      expect(described_class.organized).to eq(expected_interactors)
    end

    context 'when successfully destroyed playlist' do
      context 'when return proper count playlists after destroy' do
        let(:playlist_id) { current_user.owned_playlists.first.id }

        it 'returns proper count playlists after destroy' do
          create_list(:playlist, 3, owner: current_user)
          expect { result }.to change { current_user.owned_playlists.count }.from(3).to(2)
        end
      end

      context 'when destroying searchable playlist' do
        let(:searchable_playlist) { create(:playlist, owner: current_user) }
        let(:playlist_id) { searchable_playlist.id }

        it 'returns playlist_id of current_user for destroy' do
          expect(result.model).to eq(searchable_playlist)
        end
      end
    end

    context 'when a playlist is not found' do
      let(:playlist_id) { create(:playlist).id }

      it 'returns nil in context model' do
        expect(result.model).to be_nil
      end
    end
  end
end
