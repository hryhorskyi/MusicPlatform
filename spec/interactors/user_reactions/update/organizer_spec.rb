# frozen_string_literal: true

RSpec.describe UserReactions::Update::Organizer do
  describe '.call' do
    subject(:result) do
      described_class.call(model: user_reaction, current_user: current_user, params: params)
    end

    let(:user_reaction) { create(:user_reaction, user_id: current_user.id, playlist_id: playlist.id) }
    let(:current_user) { create(:user) }
    let(:params) { { id: user_reaction_id, playlist_id: playlist_id, reaction: reaction_type } }
    let(:user_reaction_id) { user_reaction.id }
    let(:playlist) { create(:playlist, playlist_type: 'public') }
    let(:playlist_id) { playlist.id }
    let(:reaction_type) { 'like' }
    let(:expected_interactors) do
      [
        UserReactions::Update::Initialization,
        Common::Model::Initialize,
        UserReactions::Update::FindPlaylist,
        UserReactions::Update::FindUserReaction,
        UserReactions::Update::ValidateTypeOfReaction,
        UserReactions::Update::CheckChangingOfReaction,
        Common::Model::AssignAttributes,
        Common::Policy::Check,
        Common::Model::Persist
      ]
    end

    it 'has correct interactors' do
      expect(described_class.organized).to eq(expected_interactors)
    end

    context 'when playlist exist' do
      it 'has return correct playlist' do
        expect(result.playlist.id).to eq(playlist_id)
      end
    end

    context 'when playlist not found' do
      let(:playlist_id) { 'nil' }

      it 'has return nil' do
        expect(result.playlist).to be_nil
      end

      it 'has failure result' do
        expect(result).to be_failure
      end

      it 'has correct error status' do
        expect(result.error_status).to eq(:not_found)
      end
    end

    context 'when user reaction exist' do
      it 'has return correct reaction' do
        expect(result.model.id).to eq(user_reaction_id)
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

      it 'has correct error status' do
        expect(result.error_status).to eq(:not_found)
      end
    end

    context 'when reaction type is like' do
      it 'has successfull result' do
        expect(result).to be_success
      end
    end

    context 'when reaction type is dislike' do
      before { create(:user_reaction, reaction: 'dislike') }

      it 'has successfull result' do
        expect(result).to be_success
      end
    end

    context 'when reaction is invalid' do
      let(:reaction_type) { nil }

      it 'has correct error message' do
        expected_message = I18n.t('user_reactions.update.errors.invalid_reaction')
        expect(result.model.errors.messages[:reaction].first).to eq(expected_message)
      end

      it 'has failure result' do
        expect(result).to be_failure
      end
    end
  end
end
