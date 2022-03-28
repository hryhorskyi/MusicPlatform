# frozen_string_literal: true

RSpec.describe Admin, type: :model do
  describe 'fields' do
    it { is_expected.to have_db_column(:email).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:password_digest).of_type(:string).with_options(null: false) }

    it { is_expected.to have_db_index(:email).unique(true) }
  end

  describe 'validations' do
    it { expect(build(:admin)).to validate_uniqueness_of(:email) }

    it_behaves_like 'email is valid'
    it_behaves_like 'password is valid'
  end
end
