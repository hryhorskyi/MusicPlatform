# frozen_string_literal: true

RSpec.describe Home::Index::SetBaseModel do
  describe '.call' do
    subject(:result) { described_class.call }

    let(:attributes_list) do
      %i[id
         latest_public_playlists
         latest_songs
         most_popular_playlists
         most_popular_songs
         people_with_most_friends
         top_contributors
         top_featured_public_playlists
         top_songs_in_top_genres]
    end

    it 'set all required attributes' do
      expect(result.model.to_h.keys).to eq(attributes_list)
    end

    it 'has successfull result' do
      expect(result).to be_success
    end
  end
end
