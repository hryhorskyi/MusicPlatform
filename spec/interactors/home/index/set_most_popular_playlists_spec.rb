# frozen_string_literal: true

RSpec.describe Home::Index::SetMostPopularPlaylists do
  describe '.call' do
    subject(:result) { described_class.call(model: model) }

    let(:model) { Struct.new(:most_popular_playlists).new }

    context 'with precreated playlists' do
      before do
        create_list(:playlist, 10)
      end

      it 'set right quantity of playlists' do
        expect(result.model.most_popular_playlists.count).to eq(described_class::PLAYLISTS_QUANTITY)
        expect(result).to be_success
      end
    end
  end
end
