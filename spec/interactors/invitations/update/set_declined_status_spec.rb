# frozen_string_literal: true

RSpec.describe Invitations::Update::SetDeclinedStatus do
  describe '.call' do
    subject(:result) do
      described_class.call(model: invitation)
    end

    let(:invitation) { create(:invitation) }

    context 'when all params were set correctly' do
      it 'has success result' do
        expect(result).to be_success
      end

      it 'has changed status' do
        expect { result }.to change { invitation.status }.from('pending').to('declined')
      end

      it 'has correct declined time' do
        travel_to Time.zone.now do
          expect(result.model[:declined_at]).to eq(Time.zone.now)
        end
      end
    end
  end
end
