# frozen_string_literal: true

RSpec.describe Invitations::Destroy::FindInvitation do
  describe '.call' do
    subject(:result) do
      described_class.call(current_user: requestor, params: { id: invitation_id })
    end

    let(:requestor) { create(:user) }
    let(:invitation) { create(:invitation, requestor: requestor, status: status_param) }
    let(:invitation_id) { invitation.id }
    let(:status_param) { 'pending' }

    context 'when invitation exist' do
      it 'has successfull result' do
        expect(result).to be_success
      end

      it 'has proper invitation' do
        expect(result.model).to eq(invitation)
      end

      it 'has invitation status is pending' do
        expect(result.model).to be_pending_status
      end
    end

    context 'when invitation does not exist' do
      let(:invitation_id) { nil }

      it 'has not successfull result' do
        expect(result).to be_failure
      end
    end

    context 'when current user is not requestor' do
      let(:not_requestor) { create(:user) }

      it 'has requestor is not current_user' do
        expect(result.model.requestor).not_to eq(not_requestor)
      end
    end

    context 'when invitation status is accepted' do
      let(:status_param) { 'accepted' }

      it 'has failure result' do
        expect(result).to be_failure
      end
    end

    context 'when invitation status is declined' do
      let(:status_param) { 'declined' }

      it 'has not successfull result' do
        expect(result).to be_failure
      end
    end

    context 'when invitation status is revoked' do
      let(:status_param) { 'revoked' }

      it 'has not successfull result' do
        expect(result).to be_failure
      end
    end
  end
end
