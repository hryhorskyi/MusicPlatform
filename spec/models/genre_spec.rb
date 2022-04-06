# frozen_string_literal: true

RSpec.describe Genre, type: :model do
  describe 'fields' do
    it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_index(:name).unique(true) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:song_genres) }
    it { is_expected.to have_many(:songs).through(:song_genres) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { expect(build(:genre)).to validate_uniqueness_of(:name) }
  end
end
