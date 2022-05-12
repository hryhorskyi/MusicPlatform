# frozen_string_literal: true

RSpec.describe InvitationMailer, type: :mailer do
  describe 'invitation_created' do
    let(:invitation) { create(:invitation) }
    let(:mail) { described_class.with(invitation: invitation).invitation_created.deliver_now }

    it 'renders the subject' do
      expected_message = I18n.t('mailer.invitation.action.create')
      expect(mail.subject).to eq(expected_message)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([invitation.receiver_id])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'sends an email' do
      expect { mail }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  describe '#update' do
    let(:requestor_user) { create(:user) }
    let(:receiver_user) { create(:user) }
    let(:invitation) { create(:invitation, requestor_id: requestor_user.id, receiver_id: receiver_user.id) }
    let(:mail) { described_class.with(invitation_id: invitation.id).update.deliver_now }

    it 'renders the subject' do
      expected_message = I18n.t('mailer.invitation.subject')
      expect(mail.subject).to eq(expected_message)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([requestor_user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'sends an email' do
      expect { mail }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
