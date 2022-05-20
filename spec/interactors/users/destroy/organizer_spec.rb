# frozen_string_literal: true

RSpec.describe Users::Destroy::Organizer do
  describe '.call' do
    subject(:result) do
      described_class.call(current_user: current_user, params: params)
    end

    let!(:current_user) { create(:user) }
    let(:params) { { id: current_user.id } }
    let(:expected_interactors) do
      [
        Users::Destroy::Initialize,
        Users::Destroy::FindUser,
        Common::Policy::Check,
        Common::Model::Delete
      ]
    end

    it 'has correct interactors' do
      expect(described_class.organized).to eq(expected_interactors)
    end

    context 'when successfully user destroy' do
      it 'descrease users count by 1' do
        expect { result }.to change { User.count }.by(-1)
      end
    end

    context 'when a user is not found' do
      let(:params) { { id: 'incorrect user.id' } }

      it 'returns nil in context model' do
        expect(result.model).to be_nil
      end

      it 'has failure result' do
        expect(result).to be_failure
      end
    end

    context 'when a user is not current_user' do
      let(:params) { { id: create(:user).id } }

      it 'has failure result' do
        expect(result).to be_failure
      end
    end
  end
end
