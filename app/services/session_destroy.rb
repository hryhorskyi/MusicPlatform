# frozen_string_literal: true

class SessionDestroy
  def self.call(refresh_token)
    JWTSessions::Session.new.flush_by_token(refresh_token)
  end
end
