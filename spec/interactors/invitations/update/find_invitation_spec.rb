# frozen_string_literal: true

RSpec.describe Invitations::Update::FindInvitation do
  describe '.call' do
    subject(:result) do
      described_class.call(current_user: current_user, params: { id: invitation_id })
    end

    let(:current_user) { create(:user) }
    let(:receiver) { current_user }
    let(:status) { :pending }
    let(:invitation) do
      create(:invitation, receiver: receiver, status: status)
    end
    let(:invitation_id) { invitation.id }

    context 'when invitation updated successfully' do
      it 'has success result' do
        expect(result).to be_success
      end

      it 'has correct invitation' do
        expect(result.model).to eq(invitation)
      end
    end

    context 'when invitation does not exist' do
      let(:invitation_id) { nil }

      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has correct error' do
        expected_error = I18n.t('invitation.update.errors.invitation_not_exist')
        expect(result.model.errors.messages[:id].first).to eq(expected_error)
      end
    end

    context 'when invitation exist but receiver is not current user' do
      let(:receiver) { create(:user) }

      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has correct error' do
        expected_error = I18n.t('invitation.update.errors.invitation_not_exist')
        expect(result.model.errors.messages[:id].first).to eq(expected_error)
      end
    end

    context 'when current_user is requestor of invitation' do
      let(:receiver) { create(:user) }
      let(:requestor) { current_user }

      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has correct error' do
        expected_error = I18n.t('invitation.update.errors.invitation_not_exist')
        expect(result.model.errors.messages[:id].first).to eq(expected_error)
      end
    end

    context 'when invitation status is accepted' do
      let(:status) { :accepted }

      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has correct error' do
        expected_error = I18n.t('invitation.update.errors.invitation_not_exist')
        expect(result.model.errors.messages[:id].first).to eq(expected_error)
      end
    end

    context 'when invitation status is declined' do
      let(:status) { :declined }

      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has correct error' do
        expected_error = I18n.t('invitation.update.errors.invitation_not_exist')
        expect(result.model.errors.messages[:id].first).to eq(expected_error)
      end
    end

    context 'when invitation status is revoked' do
      let(:status) { :revoked }

      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has correct error' do
        expected_error = I18n.t('invitation.update.errors.invitation_not_exist')
        expect(result.model.errors.messages[:id].first).to eq(expected_error)
      end
    end
  end
end
