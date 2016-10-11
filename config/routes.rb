require 'sidekiq/web'

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

  # sidekiq web ui
  # constraints Clearance::Constraints::SignedIn.new { |user| user.admin? } do
  #   mount Sidekiq::Web, at: '/sidekiq'
  # end
  mount Sidekiq::Web => '/sidekiq'
end
