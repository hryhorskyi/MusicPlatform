# frozen_string_literal: true

RSpec.describe 'UserReactions', type: :request do
  path '/api/v1/playlists/{id}/user_reactions' do
    post(I18n.t('swagger.user_reactions.action.post')) do
      tags I18n.t('swagger.user_reactions.tags')
      consumes 'application/json'
      parameter name: 'authorization', in: :header, type: :string, required: true
      parameter name: :id, in: :path, type: :string, example: SecureRandom.uuid
      parameter name: :user_reaction, in: :body, schema: {
        type: :object,
        properties: {
          reaction: { type: :string }
        },
        example: {
          reaction: 'like'
        },
        required: %w[reaction]
      }

      let(:id) { playlist.id }
      let(:user) { create(:user) }
      let(:playlist) { create(:playlist, playlist_type: 'public') }
      let(:user_reaction_params) { { user_id: user.id, playlist_id: playlist.id, reaction: 'like' } }

      response '201', 'user reaction created' do
        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let(:user_reaction) { user_reaction_params }

        run_test! do |response|
          expect(response).to match_json_schema('v1/user_reactions/create')
        end
      end

      response '401', 'unauthorized request' do
        let(:authorization) { '' }
        let(:user_reaction) { user_reaction_params }

        run_test!
      end

      response '403', 'when user is owner of playlist' do
        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let(:playlist) { create(:playlist, owner_id: user.id) }
        let(:user_reaction) { user_reaction_params }

        run_test!
      end

      response '403', 'when playlist type is private' do
        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let(:playlist) { create(:playlist, playlist_type: 'private') }
        let(:user_reaction) { user_reaction_params }

        run_test!
      end

      response '404', 'when playlist not found' do
        let(:id) { -1 }
        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let(:user_reaction) { { user_id: user.id, playlist_id: nil, reaction: 'like' } }

        run_test!
      end

      response '422', 'when reaction is invalid' do
        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let(:user_reaction) { { user_id: user.id, playlist_id: playlist.id, reaction: 'a' } }

        run_test!
      end

      response '422', 'when user reaction already exist' do
        before do
          create(:user_reaction,
                 user_id: user.id,
                 playlist_id: playlist.id,
                 reaction: 'like')
        end

        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let(:user_reaction) { user_reaction_params }

        run_test!
      end
    end
  end
end
