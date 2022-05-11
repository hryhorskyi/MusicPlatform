# frozen_string_literal: true

RSpec.describe 'Comments', type: :request do
  path '/api/v1/comments' do
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
