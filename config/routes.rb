# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admins, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  namespace :api do
    namespace :v1 do
      resources :friends, only: %i[index]
      resources :invitations, only: %i[create]
      resource :my_account, only: %i[show]
      resource :session, only: %i[create destroy update]
      resources :users, only: %i[index create]
    end
  end
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
end
