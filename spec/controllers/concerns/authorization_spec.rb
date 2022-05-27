# frozen_string_literal: true

RSpec.describe Authorization do
  controller(Api::V1::ApiController) do
    include Authorization
  end

  describe '#current_user' do
    context 'when access_token is not provided' do
      controller do
        def index
          render json: { user: current_user }
        end
      end

      before do
        get :index
      end

      it 'returns id of expected user in response body' do
        expect(JSON.parse(response.body)).to eq({ 'user' => nil })
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

      it 'current_user method was called once' do
        allow_any_instance_of(described_class).to receive(:current_user).once
      end
    end
  end

  describe '.authorize_user!' do
    context 'when token provided' do
      context 'when provided token is jwt token' do
        context 'when session with provided token exists' do
          context 'when user with user_id in decrypted token exists' do
            controller do
              before_action :authorize_user!

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
          end

          context 'when user with user_id in decrypted token does not exists' do
            controller do
              before_action :authorize_user!

              def index; end
            end

            before do
              request.headers['Authorization'] = bearer_token
              user.destroy
              get :index
            end

            let(:user) { create(:user) }
            let(:bearer_token) { "Bearer #{SessionCreate.call(user.id)[:access]}" }

            it 'returns :unauthorized status' do
              expect(response).to be_unauthorized
            end
          end

          context 'when there is not user_id key in decrypted token' do
            controller do
              before_action :authorize_user!

              def index
                render json: current_user
              end
            end

            before do
              request.headers['Authorization'] = bearer_token
              get :index
            end

            let(:user) { create(:user) }
            let(:token) { JWTSessions::Session.new(payload: { invalid_user_id: user.id }).login }
            let(:bearer_token) { "Bearer #{token[:access]}" }

            it 'returns :unauthorized status' do
              expect(response).to be_unauthorized
            end
          end
        end

        context 'when session with provided token does not exists' do
          controller do
            before_action :authorize_user!

            def index
              render json: { id: current_user.id }
            end
          end

          before do
            session = SessionCreate.call(user.id)
            request.headers['Authorization'] = "Bearer #{session[:access]}"
            SessionDestroy.call(session[:refresh])
            get :index
          end

          let(:user) { create(:user) }

          it 'returns :ok status' do
            expect(response).to be_unauthorized
          end
        end
      end

      context 'when provided token is not jwt token' do
        controller do
          before_action :authorize_user!

          def index; end
        end

        before do
          request.headers['Authorization'] = bearer_token
          get :index
        end

        let(:bearer_token) { 'Bearer invalid_token' }

        it 'returns :unauthorized status' do
          expect(response).to be_unauthorized
        end
      end
    end

    context 'when access_token is not provided' do
      controller do
        before_action :authorize_user!

        def index; end
      end

      before do
        get :index
      end

      it 'returns :unauthorized status' do
        expect(response).to be_unauthorized
      end
    end
  end
end
