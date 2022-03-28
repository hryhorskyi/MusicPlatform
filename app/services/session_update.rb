# frozen_string_literal: true

class SessionUpdate
  def self.call(refresh_token)
    payload = JWTSessions::Token.decode(refresh_token).first
    JWTSessions::Session.new(payload: payload).refresh(refresh_token)
  end
end
