# frozen_string_literal: true

RSpec.describe Users::Index::Organizer do
  describe '.call' do
    subject(:result) do
      described_class.call(current_user: user1, params: { exclude_friends: exclude_friends_param,
                                                          email_filter: email_filter_param })
    end

    let(:user1) { create(:user) }
    let(:user2) { create(:user, email: email_name) }
    let(:exclude_friends_param) { 'false' }
    let(:email_filter_param) { email_name }
    let(:email_name) { 'testuser2@epam.com' }
    let(:expected_interactors) do
      [
        Users::Index::SetUsers,
        Users::Index::FilterByFriends,
        Users::Index::FilterByEmail,
        Users::Index::FilterByUser,
        Common::Service::Pagination
      ]
    end

    before do
      create(:friend, initiator_id: user1.id, acceptor_id: user2.id)
    end

    it 'has correct interactors' do
      expect(described_class.organized).to eq(expected_interactors)
    end

    context 'when users successfully setted' do
      it 'has users without current_user setted to collection variable' do
        expect(result.collection).to eq([user2])
      end

      it 'has successfull result' do
        expect(result).to be_success
      end
    end

    context "when exclude_friends param is 'true'" do
      let(:exclude_friends_param) { 'true' }

      it { expect(result).to be_success }
    end

    context "when exclude_friends param is not 'true'" do
      it { expect(result).to be_success }
    end

    context 'when exclude_friends param is nil' do
      let(:exclude_friends_param) { nil }

      it 'has all users setted to collection variable' do
        expect(result.collection).to eq([user2])
      end
    end

    context 'when email_filter param found user' do
      it 'has correct user setted to collection variable' do
        expect(result.collection).to eq([user2])
      end
    end

    context "when email_filter param didn't found user" do
      let(:email_filter_param) { 'testuser3@epam.com' }

      it 'has setted to collection variable without users' do
        expect(result.collection).to be_empty
      end
    end

    context 'when email_filter param case-insensitive' do
      let(:email_filter_param) { 'TESTUSER2@epam.com' }

      it 'has setted to collection variable' do
        expect(result.collection).to eq([user2])
      end
    end

    context 'when email_filter param is nil' do
      let(:email_filter_param) { nil }

      it 'has all users setted to collection variable' do
        expect(result.collection).to eq([user2])
      end
    end
  end
end
