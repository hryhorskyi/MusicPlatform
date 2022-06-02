# frozen_string_literal: true

RSpec.describe Friends::Destroy::FindFriendship do
  describe '.call' do
    subject(:result) { described_class.call(params: { id: friendship_id }, current_user: current_user) }

    let(:current_user) { create(:user) }
    let(:friendship_id) { friendship.id }

    context 'when friendship exist' do
      context 'when current_user is initiator' do
        let(:friendship) { create(:friend, initiator: current_user) }

        it 'has proper friendship' do
          expect(result.model).to eq(friendship)
        end

        it 'has successfull result' do
          expect(result).to be_success
        end
      end

      context 'when current_user is acceptor' do
        let(:friendship) { create(:friend, acceptor: current_user) }

        it 'has proper friendship' do
          expect(result.model).to eq(friendship)
        end

        it 'has successfull result' do
          expect(result).to be_success
        end
      end
    end

    context 'when friendship is not exist' do
      let(:friendship_id) { SecureRandom.uuid }

      it 'has nil friendship' do
        expect(result.model).to be_nil
      end

      it 'has failure result' do
        expect(result).to be_failure
      end
    end
  end
end
