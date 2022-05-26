# frozen_string_literal: true

RSpec.describe UserReactions::Destroy::FindPlaylist do
  describe '.call' do
    subject(:result) { described_class.call(params: { playlist_id: playlist_id }) }

    context 'when playlist exist' do
      let(:playlist) { create(:playlist) }
      let(:playlist_id) { playlist.id }

      it 'has return correct playlist' do
        expect(result.playlist.id).to eq(playlist_id)
      end

      it 'has successfull result' do
        expect(result).to be_success
      end
    end

    context 'when playlist not found' do
      let(:playlist_id) { 'nil' }

      it 'has return nil' do
        expect(result.playlist).to be_nil
      end

      it 'has failure result' do
        expect(result).to be_failure
      end
    end
  end
end
