# frozen_string_literal: true

RSpec.describe Invitations::Destroy::SetRevokeStatus do
  describe '.call' do
    subject(:result) { described_class.call(model: invitation) }

    let(:invitation) { create(:invitation) }

    context 'when revoking invitation success' do
      it 'has updated invitation status' do
        expect { result }.to change { invitation.status }.from('pending').to('revoked')
      end

      it 'has success result' do
        expect(result).to be_success
      end
    end
  end
end
