# frozen_string_literal: true

RSpec.describe Users::Index::Organizer do
  describe '.call' do
    subject(:result) { described_class.call(current_user: user1, params: { exclude_friends: exclude_friends_param }) }

    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    let(:expected_interactors) do
      [
        Users::Index::SetUsers,
        Users::Index::FilterByFriends,
        Users::Index::FilterByUser
      ]
    end

    before do
      create(:friend, initiator_id: user1.id, acceptor_id: user2.id)
    end

    it 'has correct interactors' do
      expect(described_class.organized).to eq(expected_interactors)
    end

    context "when exclude_friends param is 'true'" do
      let(:exclude_friends_param) { 'true' }

      it { expect(result).to be_success }
    end

    context "when exclude_friends param is not 'true'" do
      let(:exclude_friends_param) { 'false' }

      it { expect(result).to be_success }
    end
  end
end
