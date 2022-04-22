# frozen_string_literal: true

RSpec.describe Invitations::Index::Organizer do
  describe '.call' do
    subject(:result) do
      described_class.call(current_user: user, params: { role_filter: filter })
    end

    let(:user) { create(:user) }
    let(:invitation_by_requestor) { create(:invitation, requestor: user) }
    let(:invitation_by_receiver) { create(:invitation, receiver: user) }
    let(:expected_interactors) do
      [
        Invitations::Index::FilterByRequestor,
        Invitations::Index::FilterByReceiver,
        Invitations::Index::AllInvitations
      ]
    end

    before { create(:invitation) }

    it 'correct interactors' do
      expect(described_class.organized).to eq(expected_interactors)
    end

    context 'when filter is requestor and filter is requestor' do
      let(:filter) { 'requestor' }

      before { invitation_by_requestor }

      it 'returns invitation where user is requestor' do
        expect(result.collection).to eq([invitation_by_requestor])
      end

      it 'has successful result' do
        expect(result).to be_success
      end
    end

    context 'when filter is receiver and filter is receiver' do
      let(:filter) { 'receiver' }

      before { invitation_by_receiver }

      it 'returns invitation where user is receiver' do
        expect(result.collection).to eq([invitation_by_receiver])
      end

      it 'has successful result' do
        expect(result).to be_success
      end
    end

    context 'when filer is incorrect' do
      let(:filter) { 'incorrect' }

      it 'returns invitations' do
        expect(result.collection).to eq([invitation_by_requestor, invitation_by_receiver])
      end

      it 'has successful result' do
        expect(result).to be_success
      end
    end

    context 'when filer is not provided' do
      let(:filter) { '' }

      it 'returns invitations' do
        expect(result.collection).to eq([invitation_by_requestor, invitation_by_receiver])
      end

      it 'has successful result' do
        expect(result).to be_success
      end
    end
  end
end
