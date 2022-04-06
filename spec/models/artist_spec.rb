# frozen_string_literal: true

RSpec.describe Artist, type: :model do
  describe 'fields' do
    it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_index(:name).unique(true) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:song_artists) }
    it { is_expected.to have_many(:songs).through(:song_artists) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
