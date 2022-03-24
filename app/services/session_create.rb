# frozen_string_literal: true

class SessionCreate
  def self.call(user_id)
    payload = { user_id: user_id }
    JWTSessions::Session.new(payload: payload, refresh_payload: payload).login
  end
end
