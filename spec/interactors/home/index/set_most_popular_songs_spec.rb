# frozen_string_literal: true

# frozen_string_literal: true

RSpec.describe Home::Index::SetMostPopularSongs do
  describe '.call' do
    subject(:result) { described_class.call(model: model) }

    before do
      create_list(:song, 10)
      create_list(:playlist_song, 10)
    end

    let(:model) { Struct.new(:most_popular_songs).new }
    let(:popular_song) { create(:song) }

    context 'when correct' do
      before do
        create_list(:playlist_song, 3, song_id: popular_song.id)
      end

      it 'has included popular song in top list' do
        expect(result.model.most_popular_songs).to include(popular_song)
      end

      it 'set right quantity of songs' do
        expect(result.model.most_popular_songs.count).to eq(described_class::SONGS_QUANTITY)
      end
    end

    context 'when incorrect' do
      it 'has top list without popular song' do
        expect(result.model.most_popular_songs).not_to include(popular_song)
      end
    end
  end
end
