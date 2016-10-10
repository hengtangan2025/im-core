Rails.application.routes.draw do
  devise_for :users, controllers: { 
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  root to: 'index#index'

  resources :organizations do
    get :trees, on: :collection
    get :show_tree, on: :member
  end

  get '/chat/:oid', to: 'chat#show', as: :chat

  # 即时消息
  mount ActionCable.server => '/cable'
end
