# frozen_string_literal: true

RSpec.describe 'Playlists', type: :request do
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
