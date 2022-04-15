# frozen_string_literal: true

RSpec.describe 'Friends', type: :request do
  path '/api/v1/friends' do
    get(I18n.t('swagger.friends.action.index')) do
      tags I18n.t('swagger.friends.tags')
      consumes 'application/json'
      parameter name: 'authorization', in: :header, type: :string, required: true

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

    post(I18n.t('swagger.friends.create')) do
      tags I18n.t('swagger.friends.tags')

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
                      invitation_id: { type: :uuid }
                    }
                  },
                  example: {
                    invitation_id: SecureRandom.uuid
                  },
                  required: %w[invitation_id]
                }

      let(:requestor) { create(:user) }
      let(:receiver) { create(:user) }
      let(:invitation) do
        create(:invitation, requestor: requestor, receiver: receiver, status: :pending)
      end

      response '201', 'when friend success created' do
        let(:authorization) { SessionCreate.call(receiver.id)[:access] }
        let(:params) { { invitation_id: invitation.id } }

        run_test! do |responce|
          expect(responce).to match_json_schema('v1/friends/create')
        end
      end

      response '401', 'unauthorized' do
        let(:authorization) { nil }
        let(:params) { { invitation_id: invitation.id } }

        run_test!
      end

      response '422', 'when invitation does not exist' do
        let(:authorization) { SessionCreate.call(receiver.id)[:access] }
        let(:params) { { invitation_id: -1 } }

        run_test! do |responce|
          expect(responce).to match_json_schema('v1/errors')
        end
      end

      response '422', 'when current_user is not receiver for provided invitation' do
        let(:authorization) { SessionCreate.call(create(:user).id)[:access] }
        let(:params) { { invitation_id: invitation.id } }

        run_test! do |responce|
          expect(responce).to match_json_schema('v1/errors')
        end
      end

      response '422', 'when invitation status is declined' do
        let(:authorization) { SessionCreate.call(receiver.id)[:access] }
        let(:invitation) do
          create(:invitation, requestor: requestor, receiver: receiver, status: :declined)
        end

        let(:params) { { invitation_id: invitation.id } }

        run_test! do |responce|
          expect(responce).to match_json_schema('v1/errors')
        end
      end

      response '422', 'when invitation status is accepted' do
        let(:authorization) { SessionCreate.call(receiver.id)[:access] }
        let(:invitation) do
          create(:invitation, requestor: requestor, receiver: receiver, status: :accepted)
        end

        let(:params) { { invitation_id: invitation.id } }

        run_test! do |responce|
          expect(responce).to match_json_schema('v1/errors')
        end
      end

      response '422', 'when invitation status raise error while updated status' do
        before do
          allow_any_instance_of(Invitation).to receive(:accepted_status!).and_raise(ActiveRecord::RecordInvalid)
        end

        let(:authorization) { SessionCreate.call(receiver.id)[:access] }
        let(:params) { { invitation_id: invitation.id } }

        run_test! do |responce|
          expect(responce).to match_json_schema('v1/errors')
        end
      end

      response '422', 'when friend model does not persist' do
        before do
          allow(Common::Model::Persist).to receive(:call)
            .with(model: instance_of(Friend))
            .and_raise(ActiveRecord::RecordInvalid)
        end

        let(:authorization) { SessionCreate.call(receiver.id)[:access] }
        let(:params) { { invitation_id: invitation.id } }

        run_test! do |responce|
          expect(responce).to match_json_schema('v1/errors')
        end
      end

      response '422', 'when current friend already created' do
        let!(:invitation) do
          create(:invitation, requestor: requestor, receiver: receiver, status: :accepted)
        end

        let(:authorization) { SessionCreate.call(receiver.id)[:access] }
        let(:params) { { invitation_id: invitation.id } }

        run_test! do |responce|
          expect(responce).to match_json_schema('v1/errors')
        end
      end
    end
  end
end
