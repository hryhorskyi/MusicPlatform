# frozen_string_literal: true

RSpec.describe Playlists::Create::Organizer do
  describe '.call' do
    subject(:result) do
      described_class.call(current_user: current_user, params: params)
    end

    let(:current_user) { create(:user) }
    let(:valid_params) { { name: 'playlist', description: 'description', playlist_type: 'public' } }
    let(:expected_interactors) do
      [
        Playlists::Create::Initialize,
        Common::Model::Initialize,
        Playlists::Create::ValidateParams,
        Playlists::Create::BuildAttributes,
        Common::Model::AssignAttributes,
        Common::Model::Validate,
        Common::Model::Persist,
        Playlists::Create::ProcessAchievement
      ]
    end

    it 'has correct interactors' do
      expect(described_class.organized).to eq(expected_interactors)
    end

    context 'when successfully created playlist with description and public type' do
      let(:params) { valid_params }

      it 'has success result' do
        expect(result).to be_success
      end

      it 'has correct owner' do
        expect(result.model.owner).to eq(current_user)
      end
    end

    context 'when successfully created playlist with description and private type' do
      let(:params) { valid_params.merge({ playlist_type: 'private' }) }

      it 'has success result' do
        expect(result).to be_success
      end

      it 'has correct owner' do
        expect(result.model.owner).to eq(current_user)
      end
    end

    context 'when successfully created playlist with description and shared type' do
      let(:params) { valid_params.merge({ playlist_type: 'shared' }) }

      it 'has success result' do
        expect(result).to be_success
      end

      it 'has correct owner' do
        expect(result.model.owner).to eq(current_user)
      end
    end

    context 'when successfully created playlist without description' do
      let(:params) { valid_params.merge({ description: nil }) }

      it 'has success result' do
        expect(result).to be_success
      end

      it 'has correct owner' do
        expect(result.model.owner).to eq(current_user)
      end

      it 'has nil description' do
        expect(result.model.description).to be_nil
      end
    end

    context 'when provided name is too short' do
      let(:params) { valid_params.merge({ name: 'p' }) }

      it 'has success result' do
        expect(result).to be_failure
      end

      it 'has correct error' do
        expected_error = I18n.t('errors.messages.too_short.other', count: Playlist::NAME_LENGTH_RANGE.min)

        expect(result.model.errors.messages[:name].first).to eq(expected_error)
      end
    end

    context 'when provided name is too long' do
      let(:params) { valid_params.merge({ name: ('p' * (Playlist::NAME_LENGTH_RANGE.max + 1)) }) }

      it 'has success result' do
        expect(result).to be_failure
      end

      it 'has correct error' do
        expected_error = I18n.t('errors.messages.too_long.other', count: Playlist::NAME_LENGTH_RANGE.max)

        expect(result.model.errors.messages[:name].first).to eq(expected_error)
      end
    end

    context 'when provided description is too long' do
      let(:params) { valid_params.merge({ description: ('d' * (Playlist::DESCRIPTION_MAX_LENGTH + 1)) }) }

      it 'has success result' do
        expect(result).to be_failure
      end

      it 'has correct error' do
        expected_error = I18n.t('errors.messages.too_long.other', count: Playlist::DESCRIPTION_MAX_LENGTH)

        expect(result.model.errors.messages[:description].first).to eq(expected_error)
      end
    end

    context 'when provided playlist_type is incorrect' do
      let(:params) { valid_params.merge({ playlist_type: 'incorrect' }) }

      it 'has success result' do
        expect(result).to be_failure
      end

      it 'has correct error' do
        expected_error = I18n.t('playlist.create.errors.invalid_playlist_type')

        expect(result.model.errors.messages[:playlist_type].first).to eq(expected_error)
      end
    end
  end
end
