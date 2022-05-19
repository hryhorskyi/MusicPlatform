# frozen_string_literal: true

RSpec.describe Users::Index::FilterByEmail do
  describe '.call' do
    subject(:result) do
      described_class.call(current_user: user1,
                           params: { email_filter: email_filter_param },
                           collection: User.all)
    end

    let(:user1) { create(:user) }
    let(:user2) { create(:user, email: email_name) }
    let(:email_name) { 'testuser2@epam.com' }

    context 'when email_filter param found user' do
      let(:email_filter_param) { email_name }

      it 'has correct user setted to collection variable' do
        expect(result.collection).to eq([user2])
      end

      it { expect(result).to be_success }
    end

    context "when email_filter param didn't found user" do
      let(:email_filter_param) { 'testuser3@epam.com' }

      it 'has setted to collection variable without users' do
        expect(result.collection).to be_empty
      end

      it { expect(result).to be_success }
    end

    context 'when email_filter param case-insensitive' do
      let(:email_filter_param) { 'TESTUSER2@epam.com' }

      it 'has setted to collection variable' do
        expect(result.collection).to eq([user2])
      end

      it { expect(result).to be_success }
    end

    context 'when email_filter param is nil' do
      let(:email_filter_param) { nil }

      it 'has all users setted to collection variable' do
        expect(result.collection).to eq([user1, user2])
      end

      it { expect(result).to be_success }
    end
  end
end
