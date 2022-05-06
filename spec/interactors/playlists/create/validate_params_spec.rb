# frozen_string_literal: true

RSpec.describe Playlists::Create::ValidateParams do
  describe '.call' do
    subject(:result) { described_class.call(model: Playlist.new, params: params) }

    context 'when a playlist_type is public' do
      let(:params) { { playlist_type: 'public' } }

      it 'has success result' do
        expect(result).to be_success
      end
    end

    context 'when a playlist_type is private' do
      let(:params) { { playlist_type: 'private' } }

      it 'has success result' do
        expect(result).to be_success
      end
    end

    context 'when a playlist_type is shared' do
      let(:params) { { playlist_type: 'shared' } }

      it 'has success result' do
        expect(result).to be_success
      end
    end

    context 'when a playlist_type is incorrect' do
      let(:params) { { playlist_type: 'incorrect' } }

      it 'has success result' do
        expect(result).to be_failure
      end

      it 'has correct error' do
        expected_error = I18n.t('playlist.create.errors.invalid_playlist_type')
        expect(result.model.errors.messages[:playlist_type].first).to eq(expected_error)
      end
    end
  end
end
