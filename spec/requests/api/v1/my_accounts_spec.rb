# frozen_string_literal: true

RSpec.describe 'MyAccounts', type: :request do
  path '/api/v1/my_account' do
    get(I18n.t('swagger.my_account.action.show')) do
      tags I18n.t('swagger.my_account.tags')
      consumes 'application/json'
      parameter name: 'authorization', in: :header, type: :string, required: true

      let!(:user) { create(:user) }

      response '200', 'ok' do
        let(:authorization) { SessionCreate.call(user.id)[:access] }

        run_test! do |response|
          expect(response).to match_json_schema('v1/my_account/show')
        end
      end

      response '401', 'unauthorized' do
        let(:authorization) { nil }

        run_test!
      end
    end

    patch(I18n.t('swagger.my_account.action.update')) do
      tags I18n.t('swagger.my_account.tags')
      consumes 'application/json'
      parameter name: 'authorization', in: :header, type: :string, required: true
      parameter name: :my_account, in: :body, schema: {
        type: :object,
        properties: {
          nickname: { type: :string },
          first_name: { type: :string },
          last_name: { type: :string }
        },
        example: {
          nickname: FFaker::Internet.user_name,
          first_name: FFaker::Name.first_name,
          last_name: FFaker::Name.last_name
        },
        required: %w[nickname first_name last_name]
      }

      let!(:current_user) { create(:user) }

      response '200', 'ok' do
        let(:authorization) { SessionCreate.call(current_user.id)[:access] }
        let(:my_account) { { nickname: current_user.nickname, first_name: 'test_name1', last_name: 'lastname' } }

        run_test! do |response|
          expect(response).to match_json_schema('v1/my_account/show')
        end
      end

      response '401', 'unauthorized' do
        let(:authorization) { nil }
        let(:my_account) { { nickname: current_user.nickname, first_name: 'test_name1', last_name: 'lastname' } }

        run_test!
      end

      response '422', 'unprocessable entity' do
        let(:authorization) { SessionCreate.call(current_user.id)[:access] }
        let(:my_account) { { nickname: '.', first_name: '.', last_name: '.' } }

        run_test! do |response|
          expect(response).to match_json_schema('v1/errors')
        end
      end
    end
  end
end
