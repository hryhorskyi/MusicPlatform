# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admins, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  namespace :api do
    namespace :v1 do
      resource :my_account, only: %i[show]
      resource :session, only: %i[create destroy update]
      resources :users, only: %i[create]
    end
  end
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
end
