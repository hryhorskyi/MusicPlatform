# frozen_string_literal: true

RSpec.describe 'Invitations', type: :request do
  path '/api/v1/invitations' do
    post(I18n.t('swagger.invitations.action.post')) do
      tags I18n.t('swagger.invitations.tags')
      consumes 'application/json'
      parameter name: 'authorization', in: :header, type: :string, required: true
      parameter name: :invitation, in: :body, schema: {
        type: :object,
        properties: {
          receiver_id: { type: :uuid }
        },
        example: {
          receiver_id: SecureRandom.uuid
        },
        required: %w[receiver_id]
      }

      let(:receiver) { create(:user) }
      let(:requestor) { create(:user) }

      response '201', 'invitation created when there are no invitations' do
        let(:authorization) { SessionCreate.call(requestor.id)[:access] }
        let(:invitation) { { receiver_id: receiver.id } }

        run_test! do |responce|
          expect(responce).to match_json_schema('v1/invitations/create')
        end
      end

      response '201', 'invitation created when invitation was declined more than 24 hours ago' do
        before do
          create(:invitation,
                 requestor_id: requestor.id,
                 receiver_id: receiver.id,
                 status: :declined,
                 declined_at: 2.days.ago)
        end

        let(:authorization) { SessionCreate.call(requestor.id)[:access] }
        let(:invitation) { { receiver_id: receiver.id } }

        run_test! do |responce|
          expect(responce).to match_json_schema('v1/invitations/create')
        end
      end

      response '401', 'unauthorized request' do
        let(:authorization) { '' }
        let(:invitation) { { receiver_id: receiver.id } }

        run_test!
      end

      response '422', 'when provided receiver does not exist' do
        let(:authorization) { SessionCreate.call(requestor.id)[:access] }
        let(:invitation) { { receiver_id: 'balblabla' } }

        run_test! do |responce|
          expect(responce).to match_json_schema('v1/errors')
        end
      end

      response '422', 'when provided receiver is already in friend list' do
        before do
          create(:invitation,
                 requestor_id: requestor.id,
                 receiver_id: receiver.id,
                 status: :accepted)
        end

        let(:authorization) { SessionCreate.call(requestor.id)[:access] }
        let(:invitation) { { receiver_id: receiver.id } }

        run_test! do |responce|
          expect(responce).to match_json_schema('v1/errors')
        end
      end

      response '422', 'when provided receiver declined the friendship request less than 24 hours ago' do
        before do
          create(:invitation,
                 requestor_id: requestor.id,
                 receiver_id: receiver.id,
                 status: :declined,
                 declined_at: 3.hours.ago)
        end

        let(:authorization) { SessionCreate.call(requestor.id)[:access] }
        let(:invitation) { { receiver_id: receiver.id } }

        run_test! do |responce|
          expect(responce).to match_json_schema('v1/errors')
        end
      end

      response '422', 'when provided receiver already requested a friendship' do
        before do
          create(:invitation,
                 requestor_id: receiver.id,
                 receiver_id: requestor.id)
        end

        let(:authorization) { SessionCreate.call(requestor.id)[:access] }
        let(:invitation) { { receiver_id: receiver.id } }

        run_test! do |responce|
          expect(responce).to match_json_schema('v1/errors')
        end
      end

      response '422', 'when current requestor already requested a friendship' do
        before do
          create(:invitation,
                 requestor_id: requestor.id,
                 receiver_id: receiver.id)
        end

        let(:authorization) { SessionCreate.call(requestor.id)[:access] }
        let(:invitation) { { receiver_id: receiver.id } }

        run_test! do |responce|
          expect(responce).to match_json_schema('v1/errors')
        end
      end
    end
  end
end
