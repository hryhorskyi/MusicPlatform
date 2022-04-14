# frozen_string_literal: true

RSpec.describe Friends::Create::FindInvitation do
  describe '.call' do
    subject(:result) do
      described_class.call(model: friend, current_user: receiver, params: { invitation_id: invitation_id })
    end

    let(:receiver) { create(:user) }
    let(:receiver_param) { receiver }
    let(:invitation) { create(:invitation, receiver: receiver_param) }
    let(:friend) { Friend.new }

    context 'when invitation exist' do
      let(:invitation_id) { invitation.id }

      it 'has successfull result' do
        expect(result).to be_success
      end

      it 'has invitation with proper receiver' do
        expect(result.invitation.receiver).to eq(receiver)
      end

      it 'has proper invitation' do
        expect(result.invitation).to eq(invitation)
      end
    end

    context 'when invitation does not exist' do
      let(:invitation_id) { nil }

      it 'has not successfull result' do
        expect(result).to be_failure
      end

      it 'has correct error message' do
        expected_message = I18n.t('friends.create.errors.invite_not_exist')
        expect(result.model.errors.messages[:invitation_id].first).to eq(expected_message)
      end

      it 'has nil invitation' do
        expect(result.invitation).to be_nil
      end
    end

    context 'when invitation exist but invitation receiver not equal current_user' do
      let(:invitation_id) { invitation.id }
      let(:receiver_param) { create(:user) }

      it 'has invitation with another receiver' do
        expect(result).to be_failure
      end
    end
  end
end
