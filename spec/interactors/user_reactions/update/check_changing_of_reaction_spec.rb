# frozen_string_literal: true

RSpec.describe UserReactions::Update::CheckChangingOfReaction do
  describe '.call' do
    subject(:result) { described_class.call(model: user_reaction, params: { reaction: reaction_type }) }

    let(:user_reaction) { create(:user_reaction, reaction: reaction_type) }
    let(:reaction_type) { 'like' }

    context 'when type of reaction changed' do
      let(:user_reaction) { create(:user_reaction, reaction: 'dislike') }

      it 'has successfull result' do
        expect(result).to be_success
      end

      it 'has different reactions' do
        expect(result.model.reaction).not_to eq(result.params[:reaction])
      end
    end

    context 'when type of reaction did not change' do
      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has correct error message' do
        expected_message = I18n.t('user_reactions.update.errors.same_reaction')
        expect(result.model.errors.messages[:reaction].first).to eq(expected_message)
      end

      it 'has identical reactions' do
        expect(result.model.reaction).to eq(result.params[:reaction])
      end
    end
  end
end
