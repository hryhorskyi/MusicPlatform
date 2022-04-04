# frozen_string_literal: true

RSpec.shared_examples 'password is valid' do
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_presence_of(:password_confirmation) }

  %w[P@ss0r p@ssw0rd P@123457 P@ssword Passw0rd].each do |invalid_password|
    it 'raise validation error with invalid password' do
      subject.password = invalid_password
      expect(subject).to be_invalid
    end
  end
end
