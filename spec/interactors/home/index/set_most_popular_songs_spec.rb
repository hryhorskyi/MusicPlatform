# frozen_string_literal: true

# frozen_string_literal: true

RSpec.describe Home::Index::SetMostPopularSongs do
  describe '.call' do
    subject(:result) { described_class.call(model: model) }

    let(:model) { Struct.new(:most_popular_songs).new }

    context 'with precreated songs' do
      before do
        create_list(:song, 10)
      end

      it 'set right quantity of songs' do
        expect(result.model.most_popular_songs.count).to eq(described_class::SONGS_QUANTITY)
        expect(result).to be_success
      end
    end
  end
end
