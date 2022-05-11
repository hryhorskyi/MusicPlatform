# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :admins, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  namespace :api do
    namespace :v1 do
      resources :comments, only: %i[create]
      resources :friends, only: %i[create index]
      resources :invitations, only: %i[create index destroy update]
      resource :my_account, only: %i[show update]
      resources :playlists, only: %i[destroy create] do
        resources :user_reactions, only: %i[create]
      end
      resource :session, only: %i[create destroy update]
      resources :users, only: %i[index create]
    end
  end
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  devise_scope :admin do
    authenticated :admin do
      mount Sidekiq::Web => '/sidekiq'
    end
  end
end
