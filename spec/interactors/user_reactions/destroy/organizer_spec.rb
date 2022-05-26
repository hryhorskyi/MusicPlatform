# frozen_string_literal: true

RSpec.describe UserReactions::Destroy::Organizer do
  describe '.call' do
    subject(:result) do
      described_class.call(model: user_reaction, current_user: current_user, params: params)
    end

    let!(:user_reaction) { create(:user_reaction, user_id: current_user.id, playlist_id: playlist.id) }
    let(:current_user) { create(:user) }
    let(:params) { { id: user_reaction_id, playlist_id: playlist_id, reaction: reaction_type } }
    let(:playlist) { create(:playlist, playlist_type: 'public') }
    let(:playlist_id) { playlist.id }
    let(:user_reaction_id) { user_reaction.id }
    let(:reaction_type) { 'like' }
    let(:expected_interactors) do
      [
        UserReactions::Destroy::Initialization,
        UserReactions::Destroy::FindPlaylist,
        UserReactions::Destroy::FindReaction,
        Common::Policy::Check,
        Common::Model::Delete
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
    end

    context 'when reaction exist' do
      it 'has successful result' do
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
    end

    context 'when successfully reaction destroyed' do
      it 'has descrease reactions count by 1' do
        expect { result.destroy }.to change { UserReaction.count }.by(-1)
      end
    end
  end
end
