# frozen_string_literal: true

RSpec.describe Comments::Index::FindPlaylist do
  describe '.call' do
    subject(:result) { described_class.call(params: { playlist_id: playlist_id }) }

    context 'when playlist exists' do
      let(:playlist) { create(:playlist) }
      let(:playlist_id) { playlist.id }

      it 'returns correct playlist' do
        expect(result.model.id).to eq(playlist_id)
      end

      it 'has successfull result' do
        expect(result).to be_success
      end
    end

    context 'when playlist is not found' do
      let(:playlist_id) { 'incorrect_id' }

      it 'returns nil' do
        expect(result.model).to be_nil
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
