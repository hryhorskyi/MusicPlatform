# frozen_string_literal: true

RSpec.describe User, type: :model do
  describe 'fields' do
    %i[nickname email password_digest].each do |field|
      it { is_expected.to have_db_column(field).of_type(:string).with_options(null: false) }
    end

    %i[first_name last_name avatar].each do |field|
      it { is_expected.to have_db_column(field).of_type(:string) }
    end

    it { is_expected.to have_db_index(:nickname).unique(true) }
    it { is_expected.to have_db_index(:email).unique(true) }
  end

  describe 'associations' do
    it {
      expect(build(:user)).to have_many(:initiated_friendships).class_name('Friend').with_foreign_key('initiator_id')
                                                               .inverse_of(:initiator).dependent(:destroy)
    }

    it {
      expect(build(:user)).to have_many(:accepted_friendships).class_name('Friend').with_foreign_key('acceptor_id')
                                                              .inverse_of(:acceptor).dependent(:destroy)
    }
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
