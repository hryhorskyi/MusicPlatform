# frozen_string_literal: true

RSpec.describe Playlists::Create::Initialize do
  describe '.call' do
    subject(:result) { described_class.call }

    context 'when a model_class successfully assigned' do
      it 'has success result' do
        expect(result).to be_success
      end

      it 'has assigned model_class' do
        expect(result.model_class).to eq(Playlist)
      end
    end
  end
end
