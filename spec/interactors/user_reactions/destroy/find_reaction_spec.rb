# frozen_string_literal: true

RSpec.describe UserReactions::Destroy::FindReaction do
  describe '.call' do
    subject(:result) { described_class.call(model: user_reaction, params: { id: user_reaction_id }) }

    context 'when user reaction exist' do
      let(:user_reaction) { create(:user_reaction) }
      let(:user_reaction_id) { user_reaction.id }

      it 'has return correct reaction' do
        expect(result.model.id).to eq(user_reaction.id)
      end

      it 'has successfull result' do
        expect(result).to be_success
      end
    end

    context 'when user reaction not found' do
      let(:user_reaction) { nil }
      let(:user_reaction_id) { nil }

      it 'has return nil' do
        expect(result.model).to be_nil
      end

      it 'has failure result' do
        expect(result).to be_failure
      end
    end
  end
end
