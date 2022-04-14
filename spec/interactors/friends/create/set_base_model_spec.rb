# frozen_string_literal: true

RSpec.describe Friends::Create::SetBaseModel do
  describe '.call' do
    subject(:result) { described_class.call(current_user: acceptor) }

    let(:acceptor) { create(:user) }

    context 'when friend successfully generated' do
      it 'has valid friend' do
        expect(result.model).to be_instance_of(Friend)
      end

      it 'has acceptor eq current_user' do
        expect(result.model.acceptor).to eq(acceptor)
      end

      it 'has successfull result' do
        expect(result).to be_success
      end
    end
  end
end
