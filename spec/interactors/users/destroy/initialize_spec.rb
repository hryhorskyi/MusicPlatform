# frozen_string_literal: true

RSpec.describe Users::Destroy::Initialize do
  describe '.call' do
    subject(:result) { described_class.call }

    context 'when a model_class successfully assigned' do
      it 'has success result' do
        expect(result).to be_success
      end

      it 'has assigned model_class' do
        expect(result.model_class).to eq(User)
      end

      it 'has assigned policy_class' do
        expect(result.policy_class).to eq(UsersPolicy)
      end

      it 'has assigned policy_method' do
        expect(result.policy_method).to eq(:destroy?)
      end
    end
  end
end
