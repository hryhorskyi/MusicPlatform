# frozen_string_literal: true

RSpec.describe PageContent, type: :model do
  describe 'fields' do
    it { is_expected.to have_db_column(:page_slug).of_type(:string).with_options(null: false) }
  end

  describe 'validations' do
    subject { build(:page_content) }

    it { is_expected.to validate_presence_of(:page_slug) }
    it { is_expected.to validate_uniqueness_of(:page_slug) }
  end

  describe 'associations' do
    it { expect(build(:page_content)).to have_rich_text(:content) }
  end
end
