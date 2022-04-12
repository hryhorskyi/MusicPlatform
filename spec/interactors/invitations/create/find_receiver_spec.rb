# frozen_string_literal: true

RSpec.describe Invitations::Create::FindReceiver do
  describe '.call' do
    subject(:result) { described_class.call(params: { receiver_id: receiver_id }, model: invitation) }

    let(:invitation) { create(:invitation, requestor: requestor, receiver: receiver) }
    let(:receiver) { create(:user) }
    let(:requestor) { create(:user) }

    context 'when provided receiver id is correct' do
      let(:receiver_id) { receiver.id }

      it 'has return correct user' do
        expect(result.receiver).to eq(receiver)
      end

      it 'has successfull result' do
        expect(result).to be_success
      end
    end

    context 'when provided receiver id is invalid' do
      let(:receiver_id) { 'blablabla' }

      it 'has return nil' do
        expect(result.receiver).to be_nil
      end

      it 'has correct error message' do
        expected_message = I18n.t('invitation.create.errors.user_not_exist')
        expect(result.model.errors.messages[:receiver_id].first).to eq(expected_message)
      end

      it 'has failure result' do
        expect(result).to be_failure
      end
    end
  end
end
