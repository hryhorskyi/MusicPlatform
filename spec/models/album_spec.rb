# frozen_string_literal: true

RSpec.describe Album, type: :model do
  describe 'fields' do
    it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:songs) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
