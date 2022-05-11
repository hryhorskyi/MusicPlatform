# frozen_string_literal: true

RSpec.describe Comments::Create::Initialize do
  describe '.call' do
    subject(:result) { described_class.call }

    context 'when a model_class successfully assigned' do
      it 'has success result' do
        expect(result).to be_success
      end

      it 'has assigned model_class' do
        expect(result.model_class).to eq(Comment)
      end

      it 'has assigned policy_class' do
        expect(result.policy_class).to eq(CommentsPolicy)
      end

      it 'has assigned policy_method' do
        expect(result.policy_method).to eq(:create?)
      end
    end
  end
end
