# frozen_string_literal: true

RSpec.describe 'Users', type: :request do
  path '/api/v1/users' do
    get(I18n.t('swagger.users.action.index')) do
      tags I18n.t('swagger.users.tags')
      produces 'application/json'
      consumes 'application/json'
      parameter name: :authorization, in: :header, type: :string, required: true
      parameter name: :exclude_friends, in: :query, type: :string, example: [true, false]

      let(:user1) { create(:user) }
      let(:user2) { create(:user) }
      let(:exclude_friends) { 'true' }
      let(:private_key) { '1234567890' }

      before do
        JWTSessions.encryption_key = private_key
        create(:friend, initiator_id: user1.id, acceptor_id: user2.id)
      end

      response '200', 'users list' do
        let(:authorization) { SessionCreate.call(user1.id)[:access] }

        run_test! do |response|
          expect(response).to match_json_schema('v1/users/index')
        end
      end

      response '401', 'unauthorized' do
        let(:authorization) { nil }

        run_test!
      end
    end

    post(I18n.t('swagger.users.action.create')) do
      tags I18n.t('swagger.users.tags')
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: { type: :object, properties: {
            email: { type: :string },
            password: { type: :string },
            password_confirmation: { type: :string },
            nickname: { type: :string }
          } }
        },
        example: {
          user: { email: 'test@gmail.com',
                  password: 'P@ssw0rd',
                  password_confirmation: 'P@ssw0rd',
                  nickname: 'Test' }
        },
        required: %w[email password password_confirmation nickname]
      }
      response '201', 'user created' do
        let(:user) { { user: attributes_for(:user) } }

        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { email: '123' } }

        run_test!
      end
    end
  end
end
