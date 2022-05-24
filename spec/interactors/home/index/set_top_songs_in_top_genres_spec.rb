# frozen_string_literal: true

RSpec.describe Home::Index::SetTopSongsInTopGenres do
  describe '.call' do
    subject(:result) { described_class.call(model: model) }

    let(:model) { Struct.new(:top_songs_in_top_genres).new }

    context 'with precreated songs' do
      before do
        create_list(:song, 15)
      end

      it 'set right quantity of songs' do
        expect(result.model.top_songs_in_top_genres.count).to eq(described_class::SONGS_QUANTITY)
        expect(result).to be_success
      end
    end
  end
end
