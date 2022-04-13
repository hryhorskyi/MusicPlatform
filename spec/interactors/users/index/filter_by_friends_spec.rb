# frozen_string_literal: true

RSpec.describe Users::Index::FilterByFriends do
  describe '.call' do
    subject(:result) do
      described_class.call(current_user: user1,
                           params: { exclude_friends: exclude_friends_param },
                           collection: User.all)
    end

    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:user3) { create(:user) }

    context "when exclude_friends param is 'true'" do
      let(:exclude_friends_param) { 'true' }

      it 'has users without friends setted to collection variable' do
        expect(result.collection).to eq([user1, user3])
      end

      it { expect(result).to be_success }
    end

    context "when exclude_friends param is not 'true'" do
      let(:exclude_friends_param) { 'false' }

      it 'has all users setted to collection variable' do
        expect(result.collection).to eq([user1, user2, user3])
      end

      it { expect(result).to be_success }
    end

    context 'when exclude_friends param is nil' do
      let(:exclude_friends_param) { nil }

      it 'has all users setted to collection variable' do
        expect(result.collection).to eq([user1, user2, user3])
      end

      it { expect(result).to be_success }
    end
  end
end
