# frozen_string_literal: true

RSpec.describe Invitations::Destroy::Organizer do
  describe '.call' do
    subject(:result) do
      described_class.call(current_user: requestor, params: { id: invitation_id })
    end

    let(:requestor) { create(:user) }
    let(:requestor_param) { requestor }
    let(:invitation_id) { invitation.id }
    let(:invitation) { create(:invitation, requestor: requestor_param, status: status_param) }
    let(:status_param) { 'pending' }
    let(:expected_interactors) do
      [
        Invitations::Destroy::FindInvitation,
        Invitations::Destroy::SetRevokeStatus,
        Invitations::Destroy::SendEmail
      ]
    end

    it 'has correct interactors' do
      expect(described_class.organized).to eq(expected_interactors)
    end

    context 'when invitation exist' do
      it 'has successfull result' do
        expect(result).to be_success
      end

      it 'has invitation with proper requestor' do
        expect(result.model.requestor).to eq(requestor)
      end

      it 'has proper invitation' do
        expect(result.model).to eq(invitation)
      end
    end

    context 'when current user is requestor' do
      let(:current_user) { invitation.requestor }

      it 'has requestor is current_user' do
        expect(result.model.requestor).to eq(current_user)
      end
    end

    context 'when invitation status is pending' do
      it 'has successfull result' do
        expect(result).to be_success
      end
    end

    context 'when revoking invitation success' do
      it 'has success result' do
        expect(result).to be_success
      end
    end

    context 'when invitation id is incorrect' do
      let(:invitation_id) { 'nil' }

      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has invitation status not updated' do
        expect { result }.not_to(change { invitation.status })
      end
    end

    context 'when invitation does not exist' do
      let(:invitation_id) { nil }

      it 'has failure result' do
        expect(result).to be_failure
      end
    end

    context 'when invitation has status accepted' do
      let(:status_param) { 'accepted' }

      it 'has invitation status not updated' do
        expect { result }.not_to(change { invitation.status })
      end

      it 'has failure result' do
        expect(result).to be_failure
      end
    end

    context 'when invitation has status declined' do
      let(:status_param) { 'declined' }

      it 'has invitation status not updated' do
        expect { result }.not_to(change { invitation.status })
      end

      it 'has failure result' do
        expect(result).to be_failure
      end
    end

    context 'when invitation has status revoked' do
      let(:status_param) { 'revoked' }

      it 'has invitation status not updated' do
        expect { result }.not_to(change { invitation.status })
      end

      it 'has failure result' do
        expect(result).to be_failure
      end
    end
  end
end
