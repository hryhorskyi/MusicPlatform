# frozen_string_literal: true

module Authorization
  extend ActiveSupport::Concern

  private

  def authorize_by_access_token!
    return if @_access_request_authorized

    authorize_access_request!
    @_access_request_authorized = true
  end

  def authorize_user!
    authorize_by_access_token!
    raise JWTSessions::Errors::Unauthorized if current_user.blank?
  end

  def current_user
    return @current_user if @_current_user_search_completed
    return if request.headers['Authorization'].blank?

    authorize_by_access_token!

    @_current_user_search_completed = true
    @current_user = User.find_by(id: payload['user_id'])
    raise JWTSessions::Errors::Unauthorized unless @current_user

    @current_user
  end
end
