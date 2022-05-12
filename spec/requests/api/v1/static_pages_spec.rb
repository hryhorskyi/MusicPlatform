# frozen_string_literal: true

RSpec.describe 'StaticPages', type: :request do
  path '/api/v1/static_pages/{id}' do
    get(I18n.t('swagger.static_pages.action.show')) do
      tags I18n.t('swagger.static_pages.tags')

      produces 'application/json'
      consumes 'application/json'

      parameter name: :id, in: :path, type: :string, required: true, example: FFaker::Lorem.word

      let(:page) { create(:page_content) }

      response '200', 'ok' do
        let(:id) { page.page_slug }

        run_test! do |response|
          expect(response).to match_json_schema('v1/static_pages/show')
        end
      end

      response '404', 'when page_slug incorrect' do
        let(:id) { 'abra-ka-da-bra' }

        run_test!
      end
    end
  end
end
