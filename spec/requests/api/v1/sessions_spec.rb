# frozen_string_literal: true

RSpec.describe I18n.t('swagger.sessions.name'), swagger_doc: 'v1/swagger.yaml', type: 'request' do
  path '/api/v1/session' do
    delete(I18n.t('swagger.sessions.actions.delete')) do
      tags I18n.t('swagger.sessions.name')
      response(204, 'no content') do
        run_test!
      end
    end
  end
end
