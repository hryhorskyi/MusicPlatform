# frozen_string_literal: true

RSpec.describe SessionDestroy, type: :service do
  describe '.call' do
    let(:user_id) { 1 }
    let(:session) { SessionCreate.call(user_id) }
    let(:refresh_token) { session[:refresh] }
    let(:invalid_token) { JWTSessions::Token.encode(payload: { user_id: user_id }, uid: 'fbd4a448-9615-4959') }

    it 'successfully deleted token' do
      expect(described_class.call(refresh_token)).to eq(1)
    end

    it 'refresh token is invalid' do
      expect { described_class.call(invalid_token) }.to raise_error(JWTSessions::Errors::Unauthorized)
    end
  end
end
