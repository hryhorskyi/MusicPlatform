# frozen_string_literal: true

RSpec.describe UserReaction, type: :model do
  describe 'fields' do
    it { is_expected.to have_db_column(:user_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:playlist_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:reaction).of_type(:integer) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:playlist) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:reaction) }
  end
end
