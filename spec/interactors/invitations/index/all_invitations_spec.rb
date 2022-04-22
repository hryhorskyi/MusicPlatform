# frozen_string_literal: true

RSpec.describe Invitations::Index::AllInvitations do
  describe '.call' do
    subject(:result) { described_class.call(current_user: requestor) }

    let(:requestor) { create(:user) }
    let(:receiver) { create(:user) }
    let(:invitation) { create(:invitation, requestor: requestor, receiver: receiver) }

    context 'when invitations exist' do
      it 'returns invitations' do
        expect(result.collection).to eq([invitation])
      end

      it 'has successful result' do
        expect(result).to be_success
      end
    end

    context 'when invitations not exist' do
      let(:invitation) { nil }

      it 'returns empty invitations list' do
        expect(result.collection).to be_empty
      end

      it 'has successful result' do
        expect(result).to be_success
      end
    end
  end
end
