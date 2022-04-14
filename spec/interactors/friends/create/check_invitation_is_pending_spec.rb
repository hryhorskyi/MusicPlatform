# frozen_string_literal: true

RSpec.describe Friends::Create::CheckInvitationIsPending do
  describe '.call' do
    subject(:result) { described_class.call(model: friend, invitation: invitation) }

    let(:invitation) { create(:invitation, status: status) }
    let(:friend) { Friend.new }

    context 'when invitation status is pending' do
      let(:status) { :pending }

      it 'has invitation status is pending' do
        expect(invitation).to be_pending_status
      end

      it 'has successfull result' do
        expect(result).to be_success
      end
    end

    context 'when invitation status is accepted' do
      let(:status) { :accepted }

      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has invitation status is accepted' do
        expect(invitation).to be_accepted_status
      end

      it 'has correct error message' do
        expected_message = I18n.t('friends.create.errors.invite_not_pending')
        expect(result.model.errors.messages[:invitation_id].first).to eq(expected_message)
      end
    end

    context 'when invitation status is declined' do
      let(:status) { :declined }

      it 'has not successfull result' do
        expect(result).to be_failure
      end

      it 'has invitation status is declined' do
        expect(invitation).to be_declined_status
      end

      it 'has correct error message' do
        expected_message = I18n.t('friends.create.errors.invite_not_pending')
        expect(result.model.errors.messages[:invitation_id].first).to eq(expected_message)
      end
    end
  end
end
