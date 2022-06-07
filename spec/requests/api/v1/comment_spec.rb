# frozen_string_literal: true

RSpec.describe 'Comments', type: :request do
  path '/api/v1/comments' do
    get(I18n.t('swagger.comments.action.index')) do
      tags I18n.t('swagger.comments.tags')
      consumes 'application/json'
      produces 'application/json'

      parameter name: 'authorization', in: :header, type: :string, required: false
      parameter name: :playlist_id, in: :query, type: :string, required: true, example: SecureRandom.uuid
      parameter name: :page, in: :query, type: :string, required: false, example: 2
      parameter name: :per_page, in: :query, type: :string, required: false, example: 20
      parameter name: :after, in: :query, type: :string, required: false, example: SecureRandom.uuid

      let(:playlist_id) { playlist.id }
      let(:playlist) { create(:playlist) }

      before do
        create(:comment, playlist: playlist)
      end

      response '200', 'when playlist is public' do
        let(:playlist) { create(:playlist, :public) }

        run_test! do |response|
          expect(response).to match_json_schema('v1/comments/index')
        end
      end

      response '200', 'when playlist is shared and user is owner' do
        let(:user) { create(:user) }
        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let(:playlist) { create(:playlist, :shared, owner: user) }

        run_test! do |response|
          expect(response).to match_json_schema('v1/comments/index')
        end
      end

      response '200', 'when playlist is shared and user is owners friend' do
        let(:user) { create(:user) }
        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let(:owner) { create(:user) }
        let(:playlist) { create(:playlist, :shared, owner: owner) }

        before do
          create(:friend, initiator: owner, acceptor: user)
        end

        run_test! do |response|
          expect(response).to match_json_schema('v1/comments/index')
        end
      end

      response '200', 'when user provides page and per_page parameters' do
        let(:playlist) { create(:playlist, :public) }
        let(:page) { 1 }
        let(:per_page) { 5 }

        before do
          create_list(:comment, 10, playlist: playlist)
        end

        run_test! do |response|
          expect(response).to match_json_schema('v1/comments/index')
        end
      end

      response '200', 'when user provides after and per_page parameters' do
        let(:playlist) { create(:playlist, :public) }
        let(:after) { Comment.order(Pagy::DEFAULT[:default_order]).first.id }
        let(:per_page) { 5 }

        before do
          create_list(:comment, 10, playlist: playlist)
        end

        run_test! do |response|
          expect(response).to match_json_schema('v1/comments/index')
        end
      end

      response '403', 'when playlist is shared and user is not owner or friend of owner' do
        let(:user) { create(:user) }
        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let(:playlist) { create(:playlist, :shared) }

        run_test!
      end

      response '403', 'when playlist is shared and user is guest' do
        let(:playlist) { create(:playlist, :shared) }

        run_test!
      end

      response '403', 'when playlist is private' do
        let(:user) { create(:user) }
        let(:playlist) { create(:playlist, :private, owner: user) }
        let(:authorization) { SessionCreate.call(user.id)[:access] }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:authorization) { 'invalid token' }

        run_test!
      end
    end

    post(I18n.t('swagger.comments.action.post')) do
      tags I18n.t('swagger.comments.tags')
      consumes 'application/json'
      parameter name: 'authorization', in: :header, type: :string, required: true
      parameter name: :comment, in: :body, schema: {
        type: :object,
        properties: {
          playlist_id: { type: :uuid },
          text: { type: :string }
        },
        example: {
          playlist_id: SecureRandom.uuid,
          text: 'some text'
        },
        required: %w[playlist_id text]
      }

      let(:comment) { { playlist_id: playlist.id, text: text } }
      let(:playlist) { create(:playlist, :public) }
      let(:text) { 'some text comment' }
      let(:user) { create(:user) }

      response '401', 'unauthorized request' do
        let(:authorization) { nil }

        run_test!
      end

      response '404', 'playlist not found' do
        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let(:comment) { { playlist_id: nil, text: nil } }

        run_test!
      end

      response '422', 'when comment is too short' do
        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let(:text) { 'short' }

        run_test! do |response|
          expect(response).to match_json_schema('v1/errors')
        end
      end

      response '422', 'when comment is too long' do
        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let(:text) { FFaker::Lorem.characters(Comment::TEXT_LENGTH.max + 1) }

        run_test! do |response|
          expect(response).to match_json_schema('v1/errors')
        end
      end

      response '403', 'when a user has more than 3 comments and the last comments was written in less than 1 minute' do
        let(:authorization) { SessionCreate.call(user.id)[:access] }

        before do
          create_list(:comment,
                      CommentsPolicy::AVAILABLE_COMMENTS_COUNT_PER_MINUTE,
                      playlist_id: playlist.id,
                      user_id: user.id)
        end

        run_test!
      end

      response '403', 'when playlist is private' do
        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let(:playlist) { create(:playlist, :private) }

        run_test!
      end

      response '403', 'when playlist is shared and user dont have friendship with playlist owner' do
        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let(:playlist) { create(:playlist, :shared) }

        run_test!
      end

      response '201', 'when playlist is public' do
        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let(:playlist) { create(:playlist, :public) }

        run_test! do |response|
          expect(response).to match_json_schema('v1/comments/create')
        end
      end

      response '201', 'when playlist is shared and user have friendship with playlist owner' do
        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let(:playlist) { create(:playlist, :shared) }

        before do
          create(:friend, initiator_id: user.id, acceptor_id: playlist.owner_id)
        end

        run_test! do |response|
          expect(response).to match_json_schema('v1/comments/create')
        end
      end

      response '201', 'when playlist is shared and user playlist owner' do
        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let(:playlist) { create(:playlist, :shared, owner_id: user.id) }

        run_test! do |response|
          expect(response).to match_json_schema('v1/comments/create')
        end
      end
    end
  end
end
