# frozen_string_literal: true

RSpec.describe Comments::Create::FindPlaylist do
  describe '.call' do
    subject(:result) { described_class.call(params: { playlist_id: playlist_id }) }

    context 'when playlist is exist' do
      let(:playlist) { create(:playlist) }
      let(:playlist_id) { playlist.id }

      it 'has return correct playlist' do
        expect(result.playlist.id).to eq(playlist_id)
      end

      it 'has success result' do
        expect(result).to be_success
      end
    end

    context 'when playlist not found' do
      let(:playlist_id) { 'incorrect_id' }

      it 'has return nil' do
        expect(result.playlist).to be_nil
      end

      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has correct status' do
        expect(result.error_status).to eq(:not_found)
      end
    end
  end
end
