# frozen_string_literal: true

RSpec.describe PlaylistSong, type: :model do
  describe 'fields' do
    it { is_expected.to have_db_column(:user_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:song_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:playlist_id).of_type(:uuid) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:song) }
    it { is_expected.to belong_to(:playlist) }
  end

  describe 'validations' do
    it { expect(build(:playlist_song)).to validate_uniqueness_of(:song).scoped_to(:playlist_id) }
  end
end
