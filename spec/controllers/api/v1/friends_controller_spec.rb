# frozen_string_literal: true

RSpec.describe Api::V1::FriendsController, type: :controller do
  describe 'GET index' do
    let!(:user) { create(:user) }
    let(:access_token) { "Bearer #{SessionCreate.call(user.id)[:access]}" }

    before do
      request.headers['Authorization'] = access_token
      JWTSessions.encryption_key = '1234567890'
    end

    context 'when current_user is initiator', :n_plus_one do
      populate { |n| create_list(:friend, n, initiator: user) }

      specify do
        expect { get :index }.to perform_constant_number_of_queries
      end
    end

    context 'when current_user is acceptor', :n_plus_one do
      populate { |n| create_list(:friend, n, acceptor: user) }

      specify do
        expect { get :index }.to perform_constant_number_of_queries
      end
    end
  end
end
