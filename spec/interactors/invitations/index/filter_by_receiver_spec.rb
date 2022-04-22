# frozen_string_literal: true

RSpec.describe Invitations::Index::FilterByReceiver do
  describe '.call' do
    subject(:result) { described_class.call(current_user: user1, params: { role_filter: filter }) }

    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:filter) { 'receiver' }

    context 'when filter param is receiver' do
      before { create_list(:invitation, 5) }

      let(:invitation) { create(:invitation, requestor: user2, receiver: user1) }

      context 'when invitations of other users also exist' do
        it 'returns invitations where provided user is receiver' do
          expect(result.collection).to eq([invitation])
        end
      end

      context 'when invitations where provided user is a requestor also exist' do
        before { create_list(:invitation, 5, requestor: user1) }

        it 'returns invitations where provided user is receiver' do
          expect(result.collection).to eq([invitation])
        end
      end

      it 'has successful result' do
        expect(result).to be_success
      end
    end

    context 'when filter is receiver and invitations not exist' do
      it 'returns empty array of invitations' do
        expect(result.collection).to be_empty
      end

      it 'has successful result' do
        expect(result).to be_success
      end
    end

    context 'when filter is not receiver' do
      let(:filter) { 'blabla' }

      it 'returns empty result of invitations' do
        expect(result.collection).to be_nil
      end

      it 'has successful result' do
        expect(result).to be_success
      end
    end
  end
end
