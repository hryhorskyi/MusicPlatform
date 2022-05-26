# frozen_string_literal: true

RSpec.describe PlaylistSongs::Create::FindSong do
  describe '.call' do
    subject(:result) { described_class.call(params: { song_id: song_id }) }

    context 'when song is exist' do
      let(:song) { create(:song) }
      let(:song_id) { song.id }

      it 'has return correct playlist' do
        expect(result.song.id).to eq(song_id)
      end

      it 'has success result' do
        expect(result).to be_success
      end
    end

    context 'when song not found' do
      let(:song_id) { 'incorrect_id' }

      it 'has return nil' do
        expect(result.song).to be_nil
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
