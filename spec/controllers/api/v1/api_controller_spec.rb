# frozen_string_literal: true

RSpec.describe Api::V1::ApiController, type: :controller do
  describe '#current_user' do
    before { JWTSessions.encryption_key = '1234567890' }

    context 'when access_token is not provided' do
      controller do
        def index
          render json: current_user
        end
      end

      before do
        get :index
      end

      it 'returns unauthorized status' do
        expect(response).to be_unauthorized
      end
    end

    context 'when access_token provided but it is invalid' do
      controller do
        def index
          render json: current_user
        end
      end

      before do
        request.headers['Authorization'] = bearer_token
        get :index
      end

      let(:bearer_token) { "Bearer #{SecureRandom.uuid}" }

      it 'returns unauthorized status' do
        expect(response).to be_unauthorized
      end
    end

    context 'when access_token provided but there is no user_id key inside' do
      controller do
        def index
          render json: current_user
        end
      end

      before do
        request.headers['Authorization'] = bearer_token
        get :index
      end

      let(:token) { JWTSessions::Session.new(payload: { admin_id: 3 }).login }
      let(:bearer_token) { "Bearer #{token[:access]}" }

      it 'returns unauthorized status' do
        expect(response).to be_unauthorized
      end
    end

    context 'when access_token provided but there is no user with provided user_id' do
      controller do
        def index
          render json: current_user
        end
      end

      before do
        request.headers['Authorization'] = bearer_token
        get :index
      end

      let(:bearer_token) { "Bearer #{SessionCreate.call(-1)[:access]}" }

      it 'returns unauthorized status' do
        expect(response).to be_unauthorized
      end
    end

    context 'when access_token provided and user with provided user_id exist' do
      controller do
        before_action :authorize_access_request!

        def index
          render json: { id: current_user.id }
        end
      end

      before do
        request.headers['Authorization'] = bearer_token
        get :index
      end

      let(:user) { create(:user) }
      let(:bearer_token) { "Bearer #{SessionCreate.call(user.id)[:access]}" }

      it 'returns :ok status' do
        expect(response).to be_ok
      end

      it 'returns id of expected user in response body' do
        expect(JSON.parse(response.body)).to eq({ 'id' => user.id })
      end
    end
  end
end
