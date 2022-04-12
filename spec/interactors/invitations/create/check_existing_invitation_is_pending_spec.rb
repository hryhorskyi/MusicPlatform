# frozen_string_literal: true

RSpec.describe Invitations::Create::CheckExistingInvitationIsPending do
  describe '.call' do
    subject(:result) do
      described_class.call(existing_invitation: existing_invitation,
                           model: invitation,
                           current_user: requestor,
                           params: { receiver_id: receiver.id })
    end

    let(:invitation) { Invitation.new(requestor: requestor, receiver: receiver) }
    let(:receiver) { create(:user) }
    let(:requestor) { create(:user) }
    let(:existing_invitation) do
      create(:invitation,
             status: status_param,
             requestor: requestor_param,
             receiver: receiver_param)
    end
    let(:requestor_param) { requestor }
    let(:receiver_param) { receiver }
    let(:status_param) { 'pending' }

    context 'when invitation does not exist' do
      let(:existing_invitation) { nil }

      it 'has successfull result' do
        expect(result).to be_success
      end
    end

    context 'when invitation exist with pending status and requestor invited receiver' do
      it 'has correct error message' do
        expected_message = I18n.t('invitation.create.errors.you_already_invited')
        expect(result.model.errors.messages[:receiver_id].first).to eq(expected_message)
      end

      it 'has successfull result' do
        expect(result).to be_failure
      end
    end

    context 'when invitation exist with pending status and receiver invited requestor' do
      let(:requestor_param) { receiver }
      let(:receiver_param) { requestor }

      it 'has correct error message' do
        expected_message = I18n.t('invitation.create.errors.user_already_invited')
        expect(result.model.errors.messages[:receiver_id].first).to eq(expected_message)
      end

      it 'has successfull result' do
        expect(result).to be_failure
      end
    end
  end
end
