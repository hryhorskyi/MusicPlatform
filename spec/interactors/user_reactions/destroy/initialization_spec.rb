# frozen_string_literal: true

RSpec.describe UserReactions::Destroy::Initialization do
  describe '.call' do
    subject(:result) { described_class.call }

    context 'when initionalization successfully' do
      it 'has policy class' do
        expect(result.policy_class).to eq(UserReactionPolicy)
      end

      it 'has policy method' do
        expect(result.policy_method).to eq(:destroy?)
      end
    end
  end
end
