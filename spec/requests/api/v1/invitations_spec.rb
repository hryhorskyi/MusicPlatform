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

        run_test! do |response|
          expect(response).to match_json_schema('v1/invitations/create')
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

        run_test! do |response|
          expect(response).to match_json_schema('v1/invitations/create')
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

        run_test! do |response|
          expect(response).to match_json_schema('v1/errors')
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

        run_test! do |response|
          expect(response).to match_json_schema('v1/errors')
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

        run_test! do |response|
          expect(response).to match_json_schema('v1/errors')
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

        run_test! do |response|
          expect(response).to match_json_schema('v1/errors')
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

        run_test! do |response|
          expect(response).to match_json_schema('v1/errors')
        end
      end
    end

    get(I18n.t('swagger.invitations.action.index')) do
      tags I18n.t('swagger.invitations.tags')
      produces 'application/json'
      consumes 'application/json'
      parameter name: 'authorization', in: :header, type: :string, required: true
      parameter name: :role_filter, in: :query, type: :string, example: %w[receiver requestor]

      let(:user) { create(:user) }
      let(:receiver) { create(:user) }
      let(:requestor) { create(:user) }

      response '401', 'when the user unauthorized' do
        let(:authorization) { '' }
        let(:role_filter) { '' }

        run_test!
      end

      response '200', 'when the user has no invitations' do
        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let(:role_filter) { '' }

        run_test! do |response|
          expect(response).to match_json_schema('v1/empty_response')
        end
      end

      response '200', 'when the user provides requestor filter parameters' do
        before do
          create(:invitation,
                 requestor_id: user.id,
                 receiver_id: receiver.id,
                 status: :pending)
        end

        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let(:role_filter) { 'requestor' }

        run_test! do |response|
          expect(response).to match_json_schema('v1/invitations/index')
        end
      end

      response '200', 'when the user provides receiver filter parameters' do
        before do
          create(:invitation,
                 requestor_id: requestor.id,
                 receiver_id: user.id,
                 status: :pending)
        end

        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let(:role_filter) { 'receiver' }

        run_test! do |response|
          expect(response).to match_json_schema('v1/invitations/index')
        end
      end

      response '200', 'when the user does not provide filter parameters' do
        before do
          create(:invitation,
                 requestor_id: requestor.id,
                 receiver_id: user.id,
                 status: :pending)
        end

        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let(:role_filter) { '' }

        run_test! do |response|
          expect(response).to match_json_schema('v1/invitations/index')
        end
      end

      response '200', 'when the user provide incorrect filter parameters' do
        before do
          create(:invitation,
                 requestor_id: requestor.id,
                 receiver_id: user.id,
                 status: :pending)
        end

        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let(:role_filter) { 'blabla' }

        run_test! do |response|
          expect(response).to match_json_schema('v1/invitations/index')
        end
      end

      response '200', 'when the user have invitation with non pending status' do
        before do
          create(:invitation,
                 requestor_id: user.id,
                 receiver_id: receiver.id,
                 status: :accepted)
        end

        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let(:role_filter) { 'requestor' }

        run_test! do |response|
          expect(response).to match_json_schema('v1/empty_response')
        end
      end

      context 'when test n+1 query' do
        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let!(:user) { create(:user) }

        context 'when current_user requestor and provide requestor params', :n_plus_one do
          populate { |n| create_list(:invitation, n, requestor: user) }

          specify do
            expect do
              get '/api/v1/invitations', params: { role_filter: 'requestor' }, headers: { authorization: authorization }
            end.to perform_constant_number_of_queries
          end
        end

        context 'when current_user receiver and provide receiver params', :n_plus_one do
          populate { |n| create_list(:invitation, n, receiver: user) }

          specify do
            expect do
              get '/api/v1/invitations', params: { role_filter: 'receiver' }, headers: { authorization: authorization }
            end.to perform_constant_number_of_queries
          end
        end

        context 'when current_user requestor but params not provided', :n_plus_one do
          populate { |n| create_list(:invitation, n, requestor: user) }

          specify do
            expect do
              get '/api/v1/invitations', headers: { authorization: authorization }
            end.to perform_constant_number_of_queries
          end
        end
      end
    end
  end

  path '/api/v1/invitations/id' do
    delete(I18n.t('swagger.invitations.action.delete')) do
      tags I18n.t('swagger.invitations.tags')

      consumes 'application/json'
      produces 'application/json'

      parameter name: 'authorization', in: :header, type: :string, required: true

      parameter name: :params,
                in: :body,
                schema: {
                  type: :object,
                  items: {
                    type: :object,
                    properties: {
                      invitation_id: { type: :integer }
                    }
                  },
                  example: {
                    invitation_id: 1
                  },
                  required: %w[invitation_id]
                }

      let(:requestor) { create(:user) }
      let(:receiver) { create(:user) }
      let(:invitation) do
        create(:invitation, requestor: requestor, receiver: receiver)
      end

      response '204', 'when invitation status became revoked' do
        let(:authorization) { SessionCreate.call(requestor.id)[:access] }
        let(:params) { { invitation_id: invitation.id } }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:authorization) { nil }
        let(:params) { { invitation_id: invitation.id } }

        run_test!
      end

      response '404', 'when invitation does not exist' do
        let(:authorization) { SessionCreate.call(requestor.id)[:access] }
        let(:params) { { invitation_id: -1 } }

        run_test!
      end

      response '404', 'when current_user is not requestor for provided invitation' do
        let(:authorization) { SessionCreate.call(create(:user).id)[:access] }
        let(:params) { { invitation_id: invitation.id } }

        run_test!
      end

      response '404', 'when invitation status is not pending' do
        let(:authorization) { SessionCreate.call(requestor.id)[:access] }
        let(:invitation) do
          create(:invitation, requestor: requestor, receiver: receiver, status: :revoked)
        end

        let(:params) { { invitation_id: invitation.id } }

        run_test!
      end
    end
  end
end
