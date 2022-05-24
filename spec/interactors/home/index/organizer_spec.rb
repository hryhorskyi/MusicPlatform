# frozen_string_literal: true

RSpec.describe Home::Index::Organizer do
  describe '.call' do
    subject(:result) { described_class.call }

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
  end
end
