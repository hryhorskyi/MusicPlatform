# frozen_string_literal: true

RSpec.describe SessionUpdate, type: :service do
  describe '.call' do
    before { JWTSessions.encryption_key = private_key }

    let(:private_key) { '1234567890' }
    let(:user_id) { 1 }
    let(:session) { SessionCreate.call(user_id) }
    let(:refresh_token) { session[:refresh] }
    let(:invalid_token) { JWTSessions::Token.encode(payload: { user_id: user_id }, uid: 'fbd4a448-9615-4959') }

    it 'has correct fields' do
      %i[csrf access access_expires_at].each do |field|
        expect(described_class.call(refresh_token).keys).to include(field)
      end
    end

    it 'old access token is not exist anymore' do
      described_class.call(refresh_token)
      expect(JWTSessions::Session.new.session_exists?(session[:access])).to be(false)
    end

    it 'has correct payload' do
      refreshed_token = described_class.call(refresh_token)
      decoded_token = JWTSessions::Token.decode(refreshed_token[:access]).first
      expect(decoded_token['user_id']).to eq(user_id)
    end

    it 'has invalid refresh token' do
      expect { described_class.call(invalid_token) }.to raise_error(JWTSessions::Errors::Unauthorized)
    end
  end
end
