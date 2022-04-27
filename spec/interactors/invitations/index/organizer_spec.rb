# frozen_string_literal: true

RSpec.describe Invitations::Index::Organizer do
  describe '.call' do
    subject(:result) do
      described_class.call(current_user: user, params: params)
    end

    let(:params) { { role_filter: filter, page: page, per_page: per_page } }
    let(:page) { 1 }
    let(:per_page) { 10 }
    let(:user) { create(:user) }
    let(:invitation_by_requestor) { create(:invitation, requestor: user) }
    let(:invitation_by_receiver) { create(:invitation, receiver: user) }

    let(:expected_interactors) do
      [
        Invitations::Index::FilterByRequestor,
        Invitations::Index::FilterByReceiver,
        Invitations::Index::AllInvitations,
        Common::Service::Pagination
      ]
    end

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

    context 'when provided params per_page and page' do
      before { create_list(:invitation, 10, receiver: user) }

      let(:collection) { Invitation.all }
      let(:page) { 1 }
      let(:per_page) { 5 }
      let(:filter) { nil }

      it 'has proper collection' do
        expected_collection = collection.first(per_page)
        expect(result.collection).to eq(expected_collection)
      end

      it 'has proper items invitations per page' do
        expect(result.collection.count).to eq(per_page)
      end
    end

    context 'when provided params after and filter' do
      before { create_list(:invitation, 10, requestor: user) }

      let(:collection) { Invitation.all }
      let(:after) { collection.first.id }
      let(:per_page) { 5 }
      let(:filter) { nil }

      it 'has proper collection without first invitation' do
        expected_collection_count = per_page
        expect(result.collection.count).to eq(expected_collection_count)
      end

      it 'has proper collection' do
        expected_collection = collection.first(per_page)
        expect(result.collection).to eq(expected_collection)
      end
    end
  end
end
