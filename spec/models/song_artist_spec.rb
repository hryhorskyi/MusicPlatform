# frozen_string_literal: true

RSpec.describe SongArtist, type: :model do
  describe 'fields' do
    %i[song_id artist_id].each do |field|
      it { is_expected.to have_db_column(field).of_type(:integer) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:song) }
    it { is_expected.to belong_to(:artist) }
  end
end
