# frozen_string_literal: true

RSpec.describe Invitations::Create::SetBaseModel do
  describe '.call' do
    subject(:result) { described_class.call(current_user: requestor, params: { receiver_id: receiver.id }) }

    let(:receiver) { create(:user) }
    let(:requestor) { create(:user) }

    context 'when invitation successfully generated' do
      it 'has valid invitation' do
        expect(result.model).to be_instance_of(Invitation)
      end

      it 'has successfull result' do
        expect(result).to be_success
      end
    end
  end
end
