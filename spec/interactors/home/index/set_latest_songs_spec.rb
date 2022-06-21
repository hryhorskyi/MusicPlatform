# frozen_string_literal: true

RSpec.describe Home::Index::SetLatestSongs do
  describe '.call' do
    subject(:result) { described_class.call(model: model) }

    before do
      create_list(:song, 10)
      create_list(:playlist_song, 10)
    end

    let(:model) { Struct.new(:latest_songs).new }

    context 'when correct' do
      let!(:latest_song) { create(:song) }

      it 'has included latest song in top list' do
        expect(result.model.latest_songs).to include(latest_song)
      end

      it 'set right quantity of songs' do
        expect(result.model.latest_songs.count).to eq(described_class::SONGS_QUANTITY)
      end
    end

    context 'when incorrect' do
      let(:latest_song) { nil }

      it 'has top list without latest song' do
        expect(result.model.latest_songs).not_to include(latest_song)
      end
    end
  end
end
