# frozen_string_literal: true

RSpec.describe Friends::Create::UpdateInvitationStatusPersistFriend do
  describe '.call' do
    subject(:result) { described_class.call(model: friend, invitation: invitation) }

    let(:invitation) { create(:invitation, requestor: requestor, receiver: receiver) }
    let(:friend) { build(:friend, initiator: requestor, acceptor: receiver) }
    let(:requestor) { create(:user) }
    let(:receiver) { create(:user) }

    context 'when persist friend success' do
      it 'has updated invitation status' do
        expect { result }.to change { invitation.status }.from('pending').to('accepted')
      end

      it 'has persisted friend entity' do
        expect { result }.to change { Friend.count }.from(0).to(1)
      end

      it 'has success result' do
        expect(result).to be_success
      end
    end

    context 'when invitation status updating failed' do
      before do
        allow_any_instance_of(Invitation).to receive(:accepted_status!).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'has invitation status not updated' do
        expect { result }.not_to(change { invitation.status })
      end

      it 'has proper error message' do
        expected_message = I18n.t('friends.create.errors.persist_rollback')
        expect(result.model.errors.messages[:friendship].first).to eq(expected_message)
      end

      it 'has failure result' do
        expect(result).to be_failure
      end
    end

    context 'when friend model not persisted' do
      before do
        allow(Common::Model::Persist).to receive(:call)
          .with(model: instance_of(Friend))
          .and_raise(ActiveRecord::RecordInvalid)
      end

      it 'has not persisted friend entity' do
        expect { result }.not_to(change { Friend.count })
      end

      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has proper error message' do
        expected_message = I18n.t('friends.create.errors.persist_rollback')
        expect(result.model.errors.messages[:friendship].first).to eq(expected_message)
      end

      it 'has a rollback transaction' do
        expect { result }.not_to(change { invitation.reload.status })
      end
    end
  end
end
