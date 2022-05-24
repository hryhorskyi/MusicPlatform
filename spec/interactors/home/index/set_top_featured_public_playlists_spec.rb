# frozen_string_literal: true

RSpec.describe Home::Index::SetTopFeaturedPublicPlaylists do
  describe '.call' do
    subject(:result) { described_class.call(model: model) }

    let(:model) { Struct.new(:top_featured_public_playlists).new }

    context 'with precreated playlists' do
      before do
        create_list(:playlist, 10)
      end

      it 'set right quantity of playlists' do
        expect(result.model.top_featured_public_playlists.count).to eq(described_class::PLAYLISTS_QUANTITY)
        expect(result).to be_success
      end
    end
  end
end
