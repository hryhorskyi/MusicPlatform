# frozen_string_literal: true

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'GET index' do
    let!(:user) { create(:user) }
    let(:access_token) { "Bearer #{SessionCreate.call(user.id)[:access]}" }

    before do
      request.headers['Authorization'] = access_token
      JWTSessions.encryption_key = '1234567890'
      create_list(:friend, 5, initiator: user)
    end

    context 'when call without params', :n_plus_one do
      populate { |n| create_list(:user, n) }

      specify do
        expect { get :index }.to perform_constant_number_of_queries
      end
    end

    context 'when call with exclude_friends=true param', :n_plus_one do
      populate { |n| create_list(:user, n) }

      specify do
        expect { get :index, params: { exclude_friends: 'true' } }.to perform_constant_number_of_queries
      end
    end
  end
end
