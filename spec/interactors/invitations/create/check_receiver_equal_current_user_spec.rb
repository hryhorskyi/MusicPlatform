# frozen_string_literal: true

RSpec.describe Invitations::Create::CheckReceiverEqualCurrentUser do
  describe '.call' do
    subject(:result) do
      described_class.call(model: invitation,
                           current_user: requestor,
                           params: params)
    end

    let(:invitation) { Invitation.new }
    let(:requestor) { create(:user) }

    context 'when invitation receiver is another than current_user' do
      let(:params) { { receiver_id: "#{requestor.id}123" } }

      it 'has success result' do
        expect(result).to be_success
      end
    end

    context 'when invitation receiver equal current_user' do
      let(:params) { { receiver_id: requestor.id } }

      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has correct error message' do
        expected_error = I18n.t('invitation.create.errors.receiver_equal_current_user')
        expect(result.model.errors.messages[:receiver_id].first).to eq(expected_error)
      end
    end
  end
end
