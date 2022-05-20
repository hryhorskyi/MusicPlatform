# frozen_string_literal: true

RSpec.describe Users::Destroy::FindUser do
  describe '.call' do
    subject(:result) { described_class.call(params: { id: user_id }) }

    context 'when user is exist' do
      let(:user) { create(:user) }
      let(:user_id) { user.id }

      it 'has return correct user' do
        expect(result.model.id).to eq(user.id)
      end

      it 'has success result' do
        expect(result).to be_success
      end
    end

    context 'when user not found' do
      let(:user_id) { 'incorrect_id' }

      it 'has return nil' do
        expect(result.user).to be_nil
      end

      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has correct status' do
        expect(result.error_status).to eq(:bad_request)
      end
    end
  end
end
