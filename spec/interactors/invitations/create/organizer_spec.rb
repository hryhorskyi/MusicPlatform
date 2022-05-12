# frozen_string_literal: true

RSpec.describe Invitations::Create::Organizer do
  describe '.call' do
    subject(:result) { described_class.call(current_user: requestor, params: { receiver_id: receiver_id }) }

    let(:receiver) { create(:user) }
    let(:receiver_id) { receiver.id }
    let(:requestor) { create(:user) }
    let(:existing_invitation) do
      create(:invitation,
             requestor: requestor_param,
             receiver: receiver_param,
             status: status_param,
             declined_at: declined_at_param)
    end
    let(:requestor_param) { requestor }
    let(:receiver_param) { receiver }
    let(:status_param) { 'pending' }
    let(:declined_at_param) { nil }
    let(:expected_interactors) do
      [
        Invitations::Create::SetBaseModel,
        Invitations::Create::CheckReceiverEqualCurrentUser,
        Invitations::Create::FindReceiver,
        Invitations::Create::FindExistingInvitation,
        Invitations::Create::CheckExistingInvitationIsPending,
        Invitations::Create::CheckExistingFriendship,
        Invitations::Create::CheckRecentlyDeclined,
        Common::Model::Persist,
        Invitations::Create::SendEmail
      ]
    end

    it 'has correct interactors' do
      expect(described_class.organized).to eq(expected_interactors)
    end

    context 'when invitation successfully created' do
      let(:existing_invitation) { nil }

      it 'has no invitations' do
        expect(result).to be_success
      end
    end

    context 'when invitation successfully created with another record in DB' do
      let(:declined_at_param) { 2.days.ago }
      let(:status_param) { 'declined' }

      it 'has invitation which was declined more than 24 hours ago' do
        expect(result).to be_success
      end
    end

    context 'when provided receiver does not exist' do
      let(:receiver_id) { 'blablabla' }

      it 'has correct error message and failure result' do
        expected_message = I18n.t('invitation.create.errors.user_not_exist')

        expect(result.model.errors.messages[:receiver_id].first).to eq(expected_message)
        expect(result).to be_failure
      end
    end

    context 'when provided receiver is already in friend list' do
      let(:status_param) { 'accepted' }

      before do
        existing_invitation
      end

      it 'has correct error message and failure result' do
        expected_message = I18n.t('invitation.create.errors.already_friend')

        expect(result.model.errors.messages[:receiver_id].first).to eq(expected_message)
        expect(result).to be_failure
      end
    end

    context 'when provided receiver declined the friendship request less than 24 hours ago' do
      let(:status_param) { 'declined' }
      let(:declined_at_param) { 3.hours.ago }

      before do
        existing_invitation
      end

      it 'has correct error message and failure result' do
        expected_message = I18n.t('invitation.create.errors.declined_recently')

        expect(result.model.errors.messages[:receiver_id].first).to eq(expected_message)
        expect(result).to be_failure
      end
    end

    context 'when provided receiver already requested a friendship' do
      let(:receiver_param) { requestor }
      let(:requestor_param) { receiver }

      before do
        existing_invitation
      end

      it 'has correct error message and failure result' do
        expected_message = I18n.t('invitation.create.errors.user_already_invited')

        expect(result.model.errors.messages[:receiver_id].first).to eq(expected_message)
        expect(result).to be_failure
      end
    end

    context 'when current requestor already requested a friendship' do
      let(:receiver_param) { receiver }
      let(:requestor_param) { requestor }

      before do
        existing_invitation
      end

      it 'has correct error message and failure result' do
        expected_message = I18n.t('invitation.create.errors.you_already_invited')

        expect(result.model.errors.messages[:receiver_id].first).to eq(expected_message)
        expect(result).to be_failure
      end
    end

    context 'when invitation receiver equal current_user' do
      let(:receiver_id) { requestor.id }

      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has correct error message' do
        expected_error = I18n.t('invitation.create.errors.receiver_equal_current_user')
        expect(result.model.errors.messages[:receiver_id].first).to eq(expected_error)
      end
    end
  end
end
