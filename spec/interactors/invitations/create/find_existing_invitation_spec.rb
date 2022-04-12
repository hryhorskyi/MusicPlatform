# frozen_string_literal: true

RSpec.describe Invitations::Create::FindExistingInvitation do
  describe '.call' do
    subject(:result) { described_class.call(current_user: requestor, params: { receiver_id: receiver.id }) }

    let(:receiver) { create(:user) }
    let(:requestor) { create(:user) }

    context 'when there are not invitations' do
      it 'has return nil' do
        expect(result.existing_invitation).to be_nil
      end

      it 'has successfull result' do
        expect(result).to be_success
      end
    end

    context 'when there is invitation and requestor invited receiver' do
      let!(:invitation) { create(:invitation, requestor: requestor, receiver: receiver) }

      it 'has return correct invitaion' do
        expect(result.existing_invitation).to eq(invitation)
      end

      it 'has successfull result' do
        expect(result).to be_success
      end
    end

    context 'when there is invitation and receiver invited requestor' do
      let!(:invitation) { create(:invitation, requestor: receiver, receiver: requestor) }

      it 'has return correct invitaion' do
        expect(result.existing_invitation).to eq(invitation)
      end

      it 'has successfull result' do
        expect(result).to be_success
      end
    end

    context 'when there are couple invitations' do
      before do
        create(:invitation, requestor: receiver, receiver: requestor)
        create(:invitation, requestor: requestor, receiver: receiver)
      end

      let!(:invitation_accepted) do
        create(:invitation, requestor: receiver, receiver: requestor, status: :accepted)
      end

      it 'has return correct invitaion' do
        expect(result.existing_invitation).to eq(invitation_accepted)
      end

      it 'has successfull result' do
        expect(result).to be_success
      end
    end
  end
end
