# frozen_string_literal: true

RSpec.describe Invitations::Create::CheckRecentlyDeclined do
  describe '.call' do
    subject(:result) { described_class.call(existing_invitation: existing_invitation, model: invitation) }

    let(:invitation) { Invitation.new(requestor: requestor, receiver: receiver) }
    let(:receiver) { create(:user) }
    let(:requestor) { create(:user) }
    let(:existing_invitation) do
      create(:invitation,
             status: :declined,
             requestor: requestor,
             receiver: receiver,
             declined_at: declined_at_param)
    end
    let(:declined_at_param) { 2.days.ago }

    context 'when invitation does not exist' do
      let(:existing_invitation) { nil }

      it 'has successfull result' do
        expect(result).to be_success
      end
    end

    context 'when invitation exist with declined status and is older then 24 hours' do
      it 'has successfull result' do
        expect(result).to be_success
      end
    end

    context 'when invitation exist with declined status and is younger then 24 hours' do
      let(:declined_at_param) { 3.hours.ago }

      it 'has correct error message' do
        expected_message = I18n.t('invitation.create.errors.declined_recently')
        expect(result.model.errors.messages[:receiver_id].first).to eq(expected_message)
      end

      it 'has failure result' do
        expect(result).to be_failure
      end
    end
  end
end
