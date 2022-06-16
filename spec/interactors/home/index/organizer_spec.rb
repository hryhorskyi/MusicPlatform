# frozen_string_literal: true

RSpec.describe Home::Index::Organizer do
  describe '.call' do
    subject(:result) { described_class.call(model: model) }

    before do
      create_list(:song, 10)
      create_list(:playlist_song, 10)
    end

    let(:model) { Struct.new(:most_popular_songs).new }
    let(:popular_song) { create(:song) }
    let(:expected_interactors) do
      [
        Home::Index::SetBaseModel,
        Home::Index::SetLatestPublicPlaylists,
        Home::Index::SetLatestSongs,
        Home::Index::SetMostPopularPlaylists,
        Home::Index::SetMostPopularSongs,
        Home::Index::SetPeopleWithMostFriends,
        Home::Index::SetTopContributors,
        Home::Index::SetTopFeaturedPublicPlaylists,
        Home::Index::SetTopSongsInTopGenres
      ]
    end

    it 'has correct interactors' do
      expect(described_class.organized).to eq(expected_interactors)
    end

    it 'has successfull result' do
      expect(result).to be_success
    end

    context 'when set of most popular songs works correct' do
      before do
        create_list(:playlist_song, 3, song_id: popular_song.id)
      end

      it 'has included popular song in top list' do
        expect(result.model.most_popular_songs).to include(popular_song)
      end
    end

    context 'when set of most popular songs works incorrect' do
      it 'has top list without popular song' do
        expect(result.model.most_popular_songs).not_to include(popular_song)
      end
    end
  end
end
