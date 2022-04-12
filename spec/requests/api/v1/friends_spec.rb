# frozen_string_literal: true

RSpec.describe 'Friends', type: :request do
  path '/api/v1/friends' do
    get(I18n.t('swagger.friends.action.index')) do
      tags I18n.t('swagger.friends.tags')
      consumes 'application/json'
      parameter name: 'authorization', in: :header, type: :string, required: true

      before do
        create(:friend, initiator_id: initiator.id, acceptor_id: acceptor.id)
      end

      let(:initiator) { create(:user) }
      let(:acceptor) { create(:user) }

      response '200', 'ok' do
        let(:authorization) { SessionCreate.call(initiator.id)[:access] }

        run_test! do |response|
          expect(response).to match_json_schema('v1/friends/index')
        end
      end

      response '401', 'unauthorized' do
        let(:authorization) { nil }

        run_test!
      end
    end
  end
end
