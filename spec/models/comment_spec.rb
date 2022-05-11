# frozen_string_literal: true

RSpec.describe Comment, type: :model do
  describe 'fields' do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
    it { is_expected.to have_db_column(:user_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:text).of_type(:text) }
    it { is_expected.to have_db_column(:playlist_id).of_type(:uuid) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:playlist) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:text) }

    it do
      expect(described_class.new).to validate_length_of(:text)
        .is_at_least(Comment::TEXT_LENGTH.min)
        .is_at_most(Comment::TEXT_LENGTH.max)
    end
  end
end
