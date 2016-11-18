require 'sidekiq/web'

Rails.application.routes.draw do
  # 即时消息
  mount ActionCable.server => '/cable'

  # 队列
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: { 
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  root to: 'index#index'

  resources :members

  resources :organizations do
    get :trees, on: :collection
    get :show_tree, on: :member
    get :organization_list, on: :collection
    get :edit_organization, on: :member
    post :update_organization, on: :member
  end

  resources :chat_messages do
    get :history, on: :collection
  end

  resources :users do
    get :new, on: :collection
  end

  get '/chat/:oid', to: 'chat#show', as: :chat
end
