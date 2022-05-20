# frozen_string_literal: true

RSpec.describe 'Users', type: :request do
  path '/api/v1/users' do
    get(I18n.t('swagger.users.action.index')) do
      tags I18n.t('swagger.users.tags')
      produces 'application/json'
      consumes 'application/json'
      parameter name: :authorization, in: :header, type: :string, required: true
      parameter name: :exclude_friends, in: :query, type: :string, example: [true, false]
      parameter name: :email_filter, in: :query, type: :string, example: 'useremail'
      parameter name: :page, in: :query, type: :string, required: false, example: 2
      parameter name: :per_page, in: :query, type: :string, required: false, example: 20
      parameter name: :after, in: :query, type: :string, required: false, example: SecureRandom.uuid

      let(:user1) { create(:user) }
      let(:user2) { create(:user) }
      let(:exclude_friends) { 'true' }
      let(:email_filter) { 'email' }

      before do
        create(:friend, initiator_id: user1.id, acceptor_id: user2.id)
      end

      response '200', 'users list' do
        let(:authorization) { SessionCreate.call(user1.id)[:access] }

        run_test! do |response|
          expect(response).to match_json_schema('v1/users/index')
        end
      end

      response '200', 'when test n+1 query' do
        let!(:user) { create(:user) }
        let(:access_token) { "Bearer #{SessionCreate.call(user.id)[:access]}" }

        before { create_list(:friend, 5, initiator: user) }

        context 'when call without params', :n_plus_one do
          populate { |n| create_list(:user, n) }

          specify do
            expect do
              get '/api/v1/users', headers: { authorization: access_token }
            end.to perform_constant_number_of_queries
          end
        end

        context 'when call with exclude_friends=true param', :n_plus_one do
          populate { |n| create_list(:user, n) }

          specify do
            expect do
              get '/api/v1/users', params: { exclude_friends: 'true' }, headers: { authorization: access_token }
            end.to perform_constant_number_of_queries
          end
        end

        context 'when call with email_filter param', :n_plus_one do
          populate { |n| create_list(:user, n) }

          specify do
            expect do
              get '/api/v1/users', params: { email_filter: 'email' }, headers: { authorization: access_token }
            end.to perform_constant_number_of_queries
          end
        end
      end

      response '200', 'when the user provide after, per_page parameters' do
        before do
          create_list(:user, 10)
        end

        let(:authorization) { SessionCreate.call(user1.id)[:access] }
        let(:after) { User.first.id }
        let(:per_page) { 5 }

        run_test! do |response|
          expect(response).to match_json_schema('v1/users/index')
        end
      end

      response '200', 'when the user provide page, per_page parameters' do
        before do
          create_list(:user, 10)
        end

        let(:authorization) { SessionCreate.call(user1.id)[:access] }
        let(:page) { 1 }
        let(:per_page) { 5 }

        run_test! do |response|
          expect(response).to match_json_schema('v1/users/index')
        end
      end

      response '401', 'unauthorized' do
        let(:authorization) { nil }

        run_test!
      end
    end

    post(I18n.t('swagger.users.action.create')) do
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

  path '/api/v1/users/{id}' do
    delete(I18n.t('swagger.users.action.destroy')) do
      tags I18n.t('swagger.users.tags')
      consumes 'application/json'
      parameter name: :authorization, in: :header, type: :string, required: true
      parameter name: :id, in: :path, type: :string, example: SecureRandom.uuid, required: true

      let(:user) { create(:user) }
      let(:id) { user.id }

      response '204', 'when user is successfully removed' do
        let(:authorization) { SessionCreate.call(user.id)[:access] }

        run_test!
      end

      response '400', 'when passed incorrect id' do
        let(:authorization) { SessionCreate.call(user.id)[:access] }
        let(:id) { '123' }

        run_test!
      end

      response '401', 'when user is unauthorize' do
        let(:authorization) { nil }

        run_test!
      end

      response '403', 'when current user not equal user_for_remove' do
        let(:authorization) { SessionCreate.call(user.id)[:access] }

        let(:id) { create(:user).id }

        run_test!
      end
    end
  end
end
