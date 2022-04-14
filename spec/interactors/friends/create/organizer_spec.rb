# frozen_string_literal: true

RSpec.describe Friends::Create::Organizer do
  describe '.call' do
    subject(:result) do
      described_class.call(current_user: receiver, params: { invitation_id: invitation_id })
    end

    let(:receiver) { create(:user) }
    let(:expected_interactors) do
      [
        Friends::Create::SetBaseModel,
        Friends::Create::FindInvitation,
        Friends::Create::SetInitiatorToBaseModel,
        Friends::Create::CheckInvitationIsPending,
        Friends::Create::UpdateInvitationStatusPersistFriend
      ]
    end

    it 'has correct interactors' do
      expect(described_class.organized).to eq(expected_interactors)
    end

    context 'when friendship was created' do
      let(:invitation) { create(:invitation, receiver: receiver) }
      let(:invitation_id) { invitation.id }

      it 'has successfull result' do
        expect(result).to be_success
      end

      it 'has persisted friend entity' do
        expect { result }.to change { Friend.count }.from(0).to(1)
      end
    end

    context 'when invitation id is incorrect' do
      let(:invitation) { create(:invitation, receiver: receiver) }
      let(:invitation_id) { 'nil' }

      it 'has correct error message' do
        expected_message = I18n.t('friends.create.errors.invite_not_exist')
        expect(result.model.errors.messages[:invitation_id].first).to eq(expected_message)
      end

      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has not persisted friend entity' do
        expect { result }.not_to(change { Friend.count })
      end

      it 'has invitation status not updated' do
        expect { result }.not_to(change { invitation.status })
      end
    end

    context 'when invitation has status declined' do
      let(:invitation) { create(:invitation, receiver: receiver, status: :declined) }
      let(:invitation_id) { invitation.id }

      it 'has correct error message' do
        expected_message = I18n.t('friends.create.errors.invite_not_pending')
        expect(result.model.errors.messages[:invitation_id].first).to eq(expected_message)
      end

      it 'has invitation status not updated' do
        expect { result }.not_to(change { invitation.status })
      end

      it 'has not persisted friend entity' do
        expect { result }.not_to(change { Friend.count })
      end

      it 'has failure result' do
        expect(result).to be_failure
      end
    end

    context 'when invitation has status accepted' do
      let(:invitation) { create(:invitation, receiver: receiver, status: :accepted) }
      let(:invitation_id) { invitation.id }

      it 'has correct error message' do
        expected_message = I18n.t('friends.create.errors.invite_not_pending')
        expect(result.model.errors.messages[:invitation_id].first).to eq(expected_message)
      end

      it 'has invitation status not updated' do
        expect { result }.not_to(change { invitation.status })
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

      let(:invitation) { create(:invitation, receiver: receiver) }
      let(:invitation_id) { invitation.id }

      it 'has not persisted friend entity' do
        expect(Friend.find_by(id: result.model.id)).to be_nil
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
