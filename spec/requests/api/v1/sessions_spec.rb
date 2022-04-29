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
        example: { email: 'test1@gmail.com', password: 'P@ssw0rd' },
        required: %w[email password]
      }

      response '201', 'created' do
        let(:session) do
          user = create(:user)
          { email: user.email, password: user.password }
        end

        run_test! do |response|
          expect(response).to match_json_schema('v1/sessions/session_create')
        end
      end

      response '400', 'bad request' do
        let(:session) { { email: 'email', password: 'password' } }

        run_test!
      end
    end

    put(I18n.t('swagger.sessions.action.update')) do
      tags I18n.t('swagger.sessions.tags')
      consumes 'application/json'
      parameter name: 'x-refresh-token', in: :header, type: :string, required: true

      response '200', 'ok' do
        let(:user_id) { '1' }
        let(:'x-refresh-token') { SessionCreate.call(user_id)[:refresh] }

        run_test! do |_responce|
          expect(response).to match_json_schema('v1/sessions/session_update')
        end
      end

      response '401', 'unauthorized' do
        let(:invalid_user_id) { '1' }
        let(:'x-refresh-token') do
          JWTSessions::Token.encode(payload: { user_id: invalid_user_id }, uid: 'fbd4a448-9615-4959')
        end

        run_test!
      end
    end

    delete(I18n.t('swagger.sessions.action.delete')) do
      tags I18n.t('swagger.sessions.tags')
      produces 'application/json'
      parameter name: 'x-refresh-token', in: :header, type: :string, required: true

      response(204, 'no content') do
        let(:user_id) { '1' }
        let(:'x-refresh-token') { SessionCreate.call(user_id)[:refresh] }

        run_test!
      end
    end
  end
end
