# frozen_string_literal: true

RSpec.describe 'Sessions', swagger_doc: 'v1/swagger.yaml', type: 'request' do
  path '/api/v1/session' do
    post(I18n.t('swagger.sessions.action.post')) do
      tags I18n.t('swagger.sessions.tags')
      consumes 'application/json'
      parameter name: :session, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[email password]
      }

      response '201', 'created' do
        let(:session) do
          user = create(:user)
          { email: user.email, password: user.password }
        end
        run_test! do |response|
          expect(response).to match_json_schema('v1/session')
        end
      end

      response '400', 'bad request' do
        let(:session) { { email: 'email', password: 'password' } }
        run_test!
      end
    end

    put(I18n.t('swagger.sessions.action.update')) do
      tags I18n.t('swagger.sessions.tags')
      response '200', 'ok' do
        run_test! do |responce|
          %w[csrf access access_expires_at].each do |field|
            expect(JSON.parse(responce.body).keys).to include(field)
          end
        end
      end
    end

    delete(I18n.t('swagger.sessions.action.delete')) do
      tags I18n.t('swagger.sessions.tags')
      produces 'application/json'
      parameter name: 'x-refresh-token', in: :header, type: :string, required: true

      response(204, 'no content') do
        before { JWTSessions.encryption_key = private_key }

        let(:private_key) { '1234567890' }
        let(:user_id) { '1' }
        let(:'x-refresh-token') { SessionCreate.call(user_id)[:refresh] }

        run_test!
      end
    end
  end
end
