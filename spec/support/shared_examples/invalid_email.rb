# frozen_string_literal: true

RSpec.shared_examples 'email is valid' do
  it { is_expected.to validate_presence_of(:email) }

  %w[q!@.com test@com testtest@test.com P@ssword].each do |invalid_email|
    it 'raise validation error with invalid password' do
      subject.email = invalid_email
      expect(subject).to be_invalid
    end
  end
end
