# frozen_string_literal: true

RSpec.describe UserReactions::Create::ValidateTypeOfReaction do
  describe '.call' do
    subject(:result) { described_class.call(model: user_reaction, params: { reaction: reaction_type }) }

    let(:user_reaction) { create(:user_reaction) }

    context 'when reaction type is like' do
      let(:reaction_type) { 'like' }

      it 'has successfull result' do
        expect(result).to be_success
      end
    end

    context 'when reaction type is dislike' do
      let(:reaction_type) { 'dislike' }

      it 'has successfull result' do
        expect(result).to be_success
      end
    end

    context 'when reaction is invalid' do
      let(:reaction_type) { nil }

      it 'has correct error message' do
        expected_message = I18n.t('user_reactions.create.errors.invalid_reaction')
        expect(result.model.errors.messages[:reaction].first).to eq(expected_message)
      end

      it 'has failure result' do
        expect(result).to be_failure
      end
    end
  end
end
