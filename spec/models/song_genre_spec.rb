# frozen_string_literal: true

RSpec.describe SongGenre, type: :model do
  describe 'fields' do
    %i[song_id genre_id].each do |field|
      it { is_expected.to have_db_column(field).of_type(:integer) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:song) }
    it { is_expected.to belong_to(:genre) }
  end
end
