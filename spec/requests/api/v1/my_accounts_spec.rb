# frozen_string_literal: true

RSpec.describe 'MyAccounts', type: :request do
  path '/api/v1/my_account' do
    get(I18n.t('swagger.my_account.action.show')) do
      tags I18n.t('swagger.my_account.tags')
      consumes 'application/json'
      parameter name: 'authorization', in: :header, type: :string, required: true

      before { JWTSessions.encryption_key = private_key }

      let!(:user) { create(:user) }
      let(:private_key) { '1234567890' }

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
  end
end
