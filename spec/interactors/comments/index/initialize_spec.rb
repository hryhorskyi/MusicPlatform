# frozen_string_literal: true

RSpec.describe Comments::Index::Initialize do
  describe '.call' do
    subject(:result) { described_class.call }

    context 'when attributes successfully assigned' do
      it 'has success result' do
        expect(result).to be_success
      end

      it 'has assigned policy_class' do
        expect(result.policy_class).to eq(CommentsIndexPolicy)
      end

      it 'has assigned policy_method' do
        expect(result.policy_method).to eq(:index?)
      end
    end
  end
end
