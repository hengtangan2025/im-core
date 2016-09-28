Rails.application.routes.draw do
  get '/', to: 'index#index'

  resources :organizations do
    get :trees, on: :collection
    get :show_tree, on: :member
  end
end
