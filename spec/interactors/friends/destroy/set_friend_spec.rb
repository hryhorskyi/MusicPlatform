# frozen_string_literal: true

RSpec.describe Friends::Destroy::SetFriend do
  describe '.call' do
    subject(:result) { described_class.call(model: friendship, current_user: current_user) }

    let(:current_user) { create(:user) }

    context 'when current_user is initiator' do
      let(:friendship) { create(:friend, initiator: current_user) }

      it 'returns a proper friend' do
        expect(result.friend).to eq(friendship.acceptor)
      end
    end

    context 'when current_user is acceptor' do
      let(:friendship) { create(:friend, acceptor: current_user) }

      it 'returns a proper friend' do
        expect(result.friend).to eq(friendship.initiator)
      end
    end
  end
end
