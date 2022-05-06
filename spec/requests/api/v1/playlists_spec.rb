# frozen_string_literal: true

RSpec.describe 'Playlists', type: :request do
  path '/api/v1/playlists' do
    post(I18n.t('swagger.playlists.action.post')) do
      tags I18n.t('swagger.playlists.tags')
      consumes 'application/json'
      parameter name: 'authorization', in: :header, type: :string, required: true
      parameter name: :playlist_params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          description: { type: :string },
          playlist_type: { type: :string }
        },
        example: {
          name: FFaker::Lorem.word,
          description: FFaker::Lorem.sentence,
          playlist_type: Playlist.playlist_types.keys.sample
        },
        required: %w[name description playlist_type]
      }

      let(:valid_params) { { name: 'playlist', description: 'description', playlist_type: 'public' } }
      let(:current_user) { create(:user) }

      response '201', 'playlist created when provided params are correct and playlist_type is public' do
        let(:authorization) { SessionCreate.call(current_user.id)[:access] }
        let(:playlist_params) { valid_params }

        run_test! do |response|
          expect(response).to match_json_schema('v1/playlist/create')
        end
      end

      response '201', 'playlist created when provided params are correct and playlist_type is shared' do
        let(:authorization) { SessionCreate.call(current_user.id)[:access] }
        let(:playlist_params) { valid_params.merge({ playlist_type: 'shared' }) }

        run_test! do |response|
          expect(response).to match_json_schema('v1/playlist/create')
        end
      end

      response '201', 'playlist created when provided params are correct and playlist_type is private' do
        let(:authorization) { SessionCreate.call(current_user.id)[:access] }
        let(:playlist_params) { valid_params.merge({ playlist_type: 'private' }) }

        run_test! do |response|
          expect(response).to match_json_schema('v1/playlist/create')
        end
      end

      response '201', 'playlist created when provided params are proper and with public type but description is nil' do
        let(:authorization) { SessionCreate.call(current_user.id)[:access] }
        let(:playlist_params) { valid_params.merge({ description: nil }) }

        run_test! do |response|
          expect(response).to match_json_schema('v1/playlist/create')
        end
      end

      response '401', 'unauthorized request' do
        let(:authorization) { '' }
        let(:playlist_params) { valid_params }

        run_test!
      end

      response '422', 'when provided description is incorrect' do
        let(:authorization) { SessionCreate.call(current_user.id)[:access] }
        let(:playlist_params) { valid_params.merge({ description: ('d' * (Playlist::DESCRIPTION_MAX_LENGTH + 1)) }) }

        run_test! do |response|
          expect(response).to match_json_schema('v1/errors')
        end
      end

      response '422', 'when provided name is too short' do
        let(:authorization) { SessionCreate.call(current_user.id)[:access] }
        let(:playlist_params) { valid_params.merge({ name: 'p' }) }

        run_test! do |response|
          expect(response).to match_json_schema('v1/errors')
        end
      end

      response '422', 'when provided name is too long' do
        let(:authorization) { SessionCreate.call(current_user.id)[:access] }
        let(:playlist_params) { valid_params.merge({ name: ('p' * (Playlist::NAME_LENGTH_RANGE.max + 1)) }) }

        run_test! do |response|
          expect(response).to match_json_schema('v1/errors')
        end
      end

      response '422', 'when provided playlist_type is incorrect' do
        let(:authorization) { SessionCreate.call(current_user.id)[:access] }
        let(:playlist_params) { valid_params.merge({ playlist_type: 'incorrect' }) }

        run_test! do |response|
          expect(response).to match_json_schema('v1/errors')
        end
      end
    end
  end
  path '/api/v1/playlists/{id}' do
    delete(I18n.t('swagger.playlists.action.delete')) do
      tags I18n.t('swagger.playlists.tags')

      consumes 'application/json'
      produces 'application/json'

      parameter name: 'authorization', in: :header, type: :string, required: true
      parameter name: :id, in: :path, type: :string, example: SecureRandom.uuid

      let(:current_user) { create(:user) }
      let(:playlist) do
        create(:playlist, owner: current_user)
      end

      response '204', 'when playlist success delete' do
        let(:authorization) { SessionCreate.call(current_user.id)[:access] }
        let(:id) { playlist.id }

        run_test!
      end

      response '404', 'when current_user has not the playlist' do
        let(:user_without_playlist) { create(:user) }
        let(:authorization) { SessionCreate.call(user_without_playlist.id)[:access] }
        let(:id) { playlist.id }

        run_test!
      end

      response '404', 'when playlist does not exist' do
        let(:authorization) { SessionCreate.call(current_user.id)[:access] }
        let(:id) { 'incorrect_playlist_id' }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:authorization) { nil }
        let(:id) { playlist.id }

        run_test!
      end
    end
  end
end
