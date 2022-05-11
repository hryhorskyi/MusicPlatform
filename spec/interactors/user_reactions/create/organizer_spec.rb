# frozen_string_literal: true

RSpec.describe UserReactions::Create::Organizer do
  describe '.call' do
    subject(:result) do
      described_class.call(model: user_reaction, current_user: current_user, params: params)
    end

    let(:user_reaction) { create(:user_reaction) }
    let(:current_user) { create(:user) }
    let(:params) { { playlist_id: playlist_id, reaction: reaction_type } }
    let(:playlist) { create(:playlist, playlist_type: 'public') }
    let(:playlist_id) { playlist.id }
    let(:reaction_type) { 'like' }
    let(:expected_interactors) do
      [
        UserReactions::Create::Initialization,
        Common::Model::Initialize,
        UserReactions::Create::FindPlaylist,
        UserReactions::Create::CheckExistingOfReaction,
        UserReactions::Create::ValidateTypeOfReaction,
        UserReactions::Create::BuildAttributes,
        Common::Model::AssignAttributes,
        Common::Policy::Check,
        Common::Model::Persist
      ]
    end

    it 'has correct interactors' do
      expect(described_class.organized).to eq(expected_interactors)
    end

    context 'when playlist exist' do
      let(:user_reaction) { create(:user_reaction, user_id: current_user.id, playlist_id: playlist.id) }

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

    context 'when reaction type is like' do
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

    context 'when current_user and params assigned correctly' do
      it 'has success result' do
        expect(result).to be_success
      end

      it 'has assigned model_params' do
        expect(result.model_params).to eq(params.merge({ user: current_user, playlist: playlist,
                                                         reaction: params[:reaction] }))
      end
    end
  end
end
