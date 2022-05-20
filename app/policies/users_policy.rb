# frozen_string_literal: true

class UsersPolicy < ApplicationPolicy
  attr_reader :user, :user_for_remove

  def initialize(user, user_for_remove)
    super
    @user_for_remove = user_for_remove
  end

  def destroy?
    current_user_is_owner?
  end

  private

  def current_user_is_owner?
    user == user_for_remove
  end
end
