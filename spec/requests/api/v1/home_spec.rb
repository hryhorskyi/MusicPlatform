# frozen_string_literal: true

RSpec.describe 'Home', type: :request do
  path '/api/v1/home' do
    get(I18n.t('swagger.home.action.index')) do
      tags I18n.t('swagger.home.tags')
      produces 'application/json'

      response '200', 'ok' do
        run_test! do |response|
          expect(response).to match_json_schema('v1/home/index')
        end
      end
    end
  end
end
