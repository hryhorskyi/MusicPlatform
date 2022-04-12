# frozen_string_literal: true

xdescribe 'Playlists', swagger_doc: 'v1/swagger.yaml' do
  path '/api/v1/playlists' do
    get 'show public/private playlist' do
      tags 'Playlists'
      produces 'application/json'

      response '200', 'successful' do
        let(:playlist) { create(:playlist) }

        run_test!
      end

      response '404', 'playlist not found' do
        let(:playlist) { 'not found' }

        run_test!
      end
    end
  end

  path '/api/v1/playlists/{id}' do
    patch 'update public/private playlist' do
      tags 'Playlists'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :playlist, in: :body, schema: {
        type: :object,
        properties: {
          playlist: { type: :object, properties: {
            name: { type: :string },
            description: { type: :string },
            playlist_type: { type: :string },
            logo: { type: :string },
            owner_id: { type: :integer }
          } }
        }
      }
      let(:playlist) { create(:playlist) }

      response '200', 'successful' do
        let(:id) { Playlist.update(name: 'Name').id }

        run_test!
      end

      response '404', 'playlist not found' do
        let(:id) { 'invalid' }

        run_test!
      end
    end

    put 'update public/private playlist' do
      tags 'Playlists'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :playlist, in: :body, schema: {
        type: :object,
        properties: {
          playlist: { type: :object, properties: {
            name: { type: :string },
            description: { type: :string },
            playlist_type: { type: :string },
            logo: { type: :string },
            owner_id: { type: :integer }
          } }
        }
      }
      let(:playlist) { create(:playlist) }

      response '200', 'successful' do
        let(:id) { Playlist.update(name: 'Name').id }

        run_test!
      end

      response '404', 'playlist not found' do
        let(:id) { 'invalid' }

        run_test!
      end
    end
  end

  path '/api/v1/playlists_song' do
    post 'add song to playlist' do
      tags 'Playlists'
      consumes 'application/json'
      parameter name: :playlist, in: :body, schema: {
        type: :object, properties: { name: { type: :string }, description: { type: :string },
                                     playlist_type: { type: :string }, logo: { type: :string },
                                     owner_id: { type: :integer } },
        required: %w[name description playlist_type logo owner_id]
      }

      response '201', 'song added' do
        let(:playlist) do
          {
            playlist: { name: 'Name', description: 'Description', playlist_type: 'Playlist_type',
                        logo: 'Logo', owner_id: 1 }
          }
        end

        run_test!
      end

      response '404', 'song not found' do
        let(:playlist) { 'not found' }

        run_test!
      end

      response '422', 'invalid request' do
        let(:playlist) { 'invalid' }

        run_test!
      end
    end
  end

  path '/api/v1/playlists_songs/{id}' do
    delete 'destroy song' do
      tags 'Playlists'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      let(:playlist) { create(:playlist) }

      response '204', 'song deleted from playlist' do
        let(:id) { playlist.id }

        run_test!
      end

      response '404', 'song not found' do
        let(:id) { 'invalid' }

        run_test!
      end
    end
  end
end
