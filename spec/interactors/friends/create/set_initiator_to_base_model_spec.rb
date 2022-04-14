# frozen_string_literal: true

RSpec.describe Friends::Create::SetInitiatorToBaseModel do
  describe '.call' do
    subject(:result) { described_class.call(model: friend, invitation: invitation) }

    let(:invitation) { create(:invitation, requestor: requestor) }
    let(:requestor) { create(:user) }
    let(:friend) { Friend.new }

    context 'when initiator exist' do
      it 'has initiator equal requestor' do
        expect { result }.to change { friend.initiator }.from(nil).to(requestor)
      end

      it 'has successful result' do
        expect(result).to be_success
      end
    end
  end
end
