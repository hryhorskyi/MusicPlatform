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
    context 'when user valid' do
      subject { build(:user) }

      %i[nickname email password].each do |field|
        it { is_expected.to validate_presence_of(field) }
      end

      %i[nickname email].each do |field|
        it { is_expected.to validate_uniqueness_of(field) }
      end

      it { is_expected.to validate_length_of(:nickname).is_at_least(User::NICKNAME_LENGTH.first) }
      it { is_expected.to validate_length_of(:nickname).is_at_most(User::NICKNAME_LENGTH.last) }
    end

    context 'when user invalid' do
      %w[P@ss0r p@ssw0rd P@123457 P@ssword Passw0rd].each do |invalid_password|
        it "raise validation error with invalid password: #{invalid_password}" do
          expect { create(:user, password: invalid_password) }.to raise_error(ActiveRecord::RecordInvalid,
                                                                              'Validation failed: Password is invalid')
        end
      end
    end
  end
end
