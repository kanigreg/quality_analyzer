# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    resources :checks, only: :create
  end

  scope module: :web do
    root 'home#show'

    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete 'auth/logout', to: 'auth#logout', as: :logout

    resources :repositories, only: %i[index show new create] do
      resources :checks, only: %i[create show], module: :repositories
    end
  end
end
