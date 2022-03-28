# frozen_string_literal: true

RSpec.describe User, type: :model do
  describe 'fields' do
    %i[nickname email password_digest].each do |field|
      it { is_expected.to have_db_column(field).of_type(:string).with_options(null: false) }
    end

    it { is_expected.to have_db_index(:nickname).unique(true) }
    it { is_expected.to have_db_index(:email).unique(true) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:nickname) }

    %i[nickname email].each do |field|
      it { expect(build(:user)).to validate_uniqueness_of(field) }
    end

    it { is_expected.to validate_length_of(:nickname).is_at_least(User::NICKNAME_LENGTH.first) }
    it { is_expected.to validate_length_of(:nickname).is_at_most(User::NICKNAME_LENGTH.last) }

    it_behaves_like 'email is valid'
    it_behaves_like 'password is valid'
  end
end
