# frozen_string_literal: true

RSpec.describe Achievement, type: :model do
  describe 'fields' do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
    it { is_expected.to have_db_column(:achievement_type).of_type(:integer) }
    it { is_expected.to have_db_column(:actual_count).of_type(:integer) }
    it { is_expected.to have_db_column(:user_id).of_type(:uuid) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user).class_name('User') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:actual_count) }
    it { is_expected.to validate_presence_of(:achievement_type) }
  end
end
