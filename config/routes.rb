# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, path: 'admins'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  root 'pages#home'

  get '/about', to: 'pages#about'
  get '/experience', to: 'pages#experience'
  get '/contact', to: 'contacts#show'
  resources :projects, only: %i[index show]

  namespace :admin do
    root 'dashboard#index'

    resource :profile, only: %i[show new create edit update]
    resources :projects
    resources :experiences
  end
end
