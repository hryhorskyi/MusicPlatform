# frozen_string_literal: true

RSpec.describe UserReactions::Update::Initialization do
  describe '.call' do
    subject(:result) { described_class.call }

    context 'when initionalization successfully' do
      it 'has model class' do
        expect(result.model_class).to eq(UserReaction)
      end

      it 'has policy class' do
        expect(result.policy_class).to eq(UserReactionPolicy)
      end

      it 'has policy method' do
        expect(result.policy_method).to eq(:update?)
      end
    end
  end
end
