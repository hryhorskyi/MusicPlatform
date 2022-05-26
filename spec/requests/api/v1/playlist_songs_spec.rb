# frozen_string_literal: true

RSpec.describe 'PlaylistSongs', type: :request do
  path '/api/v1/playlists/{id}/playlist_songs' do
    post(I18n.t('swagger.playlist_songs.action.post')) do
      tags I18n.t('swagger.playlist_songs.tags')
      consumes 'application/json'
      parameter name: 'authorization', in: :header, type: :string, required: true
      parameter name: :id, in: :path, type: :string, example: SecureRandom.uuid
      parameter name: :song_id, in: :body, schema: {
        type: :object,
        properties: {
          song_id: { type: :string }
        },
        example: {
          song_id: SecureRandom.uuid
        },
        required: %w[song_id]
      }

      let(:id) { playlist.id }
      let(:user) { create(:user) }
      let(:playlist) { create(:playlist, :public, owner: user) }
      let(:song) { create(:song) }
      let(:song_id) { { song_id: song.id } }

      response '201', 'song add to playlist' do
        let(:authorization) { SessionCreate.call(user.id)[:access] }

        run_test! do |response|
          expect(response).to match_json_schema('v1/playlist_songs/create')
        end
      end

      response '401', 'unauthorized request' do
        let(:authorization) { nil }
        let(:song_id) { nil }

        run_test!
      end

      response '403', 'when user is not owner of playlist' do
        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let(:playlist) { create(:playlist, :public) }

        run_test!
      end

      response '403', 'when user is friend of playlist owner and playlist is private' do
        before do
          create(:friend, initiator: user, acceptor: playlist.owner)
        end

        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let(:playlist) { create(:playlist, :private) }

        run_test!
      end

      response '404', 'when playlist not found' do
        let(:id) { -1 }
        let(:authorization) { SessionCreate.call(user.id)[:access] }

        run_test!
      end

      response '404', 'when song not found' do
        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let(:song_id) { { song_id: SecureRandom.uuid } }

        run_test!
      end

      response '422', 'when song already exist' do
        before do
          create(:playlist_song,
                 user: user,
                 playlist: playlist,
                 song: song)
        end

        let(:authorization) { SessionCreate.call(user.id)[:access] }

        run_test! do |response|
          expect(response).to match_json_schema('v1/errors')
        end
      end
    end
  end
end
