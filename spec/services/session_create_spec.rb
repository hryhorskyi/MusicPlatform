# frozen_string_literal: true

RSpec.describe SessionCreate, type: :service do
  describe '.call' do
    subject(:session) { described_class.call(user_id) }

    before { JWTSessions.encryption_key = private_key }

    let(:private_key) { '1234567890' }
    let(:user_id) { 1 }

    it 'has correct fields' do
      %i[csrf access access_expires_at refresh refresh_expires_at].each do |field|
        expect(session.keys).to include(field)
      end
    end

    it 'has correct payload' do
      decoded_token = JWTSessions::Token.decode(session[:access]).first
      expect(decoded_token['user_id']).to eq(user_id)
    end
  end
end
