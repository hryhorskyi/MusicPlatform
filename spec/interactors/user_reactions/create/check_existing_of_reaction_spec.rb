# frozen_string_literal: true

RSpec.describe UserReactions::Create::CheckExistingOfReaction do
  describe '.call' do
    subject(:result) do
      described_class.call(model: user_reaction, playlist: playlist, current_user: current_user)
    end

    let(:current_user) { create(:user) }
    let(:playlist) { create(:playlist) }

    context 'when existing reaction not found' do
      let(:user_reaction) { nil }

      it 'has successfull result' do
        expect(result).to be_success
      end
    end

    context 'when reaction already exist' do
      let(:user_reaction) { create(:user_reaction, user_id: current_user.id, playlist_id: playlist.id) }

      it 'has correct error message' do
        expected_message = I18n.t('user_reactions.create.errors.exist')
        expect(result.model.errors.messages[:reaction].first).to eq(expected_message)
      end

      it 'has failure result' do
        expect(result).to be_failure
      end
    end
  end
end
