# frozen_string_literal: true

RSpec.describe 'Users', type: :request do
  path '/api/v1/users' do
    post(I18n.t('swagger.users.action')) do
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
