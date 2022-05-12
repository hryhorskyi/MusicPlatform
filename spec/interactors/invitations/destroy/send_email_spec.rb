# frozen_string_literal: true

RSpec.describe Invitations::Destroy::SendEmail do
  describe '.call' do
    include ActiveJob::TestHelper

    subject(:result) { described_class.call(model: invitation) }

    let(:invitation) { create(:invitation) }

    context 'when email sent successfully' do
      it 'has success result' do
        expect(result).to be_success
      end

      it 'has sent email' do
        expect { result }.to change { enqueued_jobs.count }.by(1)
      end
    end

    context 'with correct job params' do
      before { result }

      it 'has correct job type' do
        expect(enqueued_jobs.first[:job]).to eq(ActionMailer::MailDeliveryJob)
      end

      it 'has correct job args' do
        mailer_class, mail_action, _, params = enqueued_jobs.first[:args]
        invitation_id = params['params']['invitation_id']
        expect([mailer_class, mail_action, invitation_id]).to eq(['InvitationMailer', 'destroy', invitation.id])
      end
    end
  end
end
