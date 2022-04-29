# frozen_string_literal: true

RSpec.describe Playlist, type: :model do
  describe 'fields' do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
    it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:description).of_type(:text) }
    it { is_expected.to have_db_column(:playlist_type).of_type(:integer) }
    it { is_expected.to have_db_column(:logo).of_type(:string) }
    it { is_expected.to have_db_column(:owner_id).of_type(:uuid) }
  end

  describe 'associations' do
    it { expect(build(:playlist)).to have_many(:user_reactions).dependent(:destroy) }
    it { is_expected.to have_many(:playlist_songs).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:songs).through(:playlist_songs) }
    it { is_expected.to belong_to(:owner).class_name('User').inverse_of(:owned_playlists) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:playlist_type) }
    it { expect(build(:playlist)).to validate_uniqueness_of(:name).scoped_to(:owner_id) }
  end
end
