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
        run_test!
      end

      response '400', 'bad request' do
        let(:session) { { email: 'email', password: 'password' } }
        run_test!
      end
    end

    delete(I18n.t('swagger.sessions.action.delete')) do
      tags I18n.t('swagger.sessions.tags')
      response(204, 'no content') do
        run_test!
      end
    end
  end
end
