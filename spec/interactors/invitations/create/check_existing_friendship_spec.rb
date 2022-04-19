# frozen_string_literal: true

RSpec.describe Invitations::Create::CheckExistingFriendship do
  describe '.call' do
    subject(:result) do
      described_class.call(existing_invitation: existing_invitation, model: invitation)
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

    context 'when invitation exist with pending status' do
      it 'has successfull result' do
        expect(result).to be_success
      end
    end

    context 'when invitation exist with declined status' do
      let(:status_param) { 'declined' }

      it 'has successfull result' do
        expect(result).to be_success
      end
    end

    context 'when invitation exist with revoked status' do
      let(:status_param) { 'revoked' }

      it 'has successfull result' do
        expect(result).to be_success
      end
    end

    context 'when invitation exist with accepted status and requestor invited receiver' do
      let(:status_param) { 'accepted' }

      it 'has correct error message' do
        expected_message = I18n.t('invitation.create.errors.already_friend')
        expect(result.model.errors.messages[:receiver_id].first).to eq(expected_message)
      end

      it 'has failure result' do
        expect(result).to be_failure
      end
    end

    context 'when invitation exist with accepted status and receiver invited requestor' do
      let(:requestor_param) { receiver }
      let(:receiver_param) { requestor }
      let(:status_param) { 'accepted' }

      it 'has correct error message' do
        expected_message = I18n.t('invitation.create.errors.already_friend')
        expect(result.model.errors.messages[:receiver_id].first).to eq(expected_message)
      end

      it 'has failure result' do
        expect(result).to be_failure
      end
    end
  end
end
