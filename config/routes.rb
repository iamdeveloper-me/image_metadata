Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  resources :photos do
    member do
      get :edit_metadata
      get :update_metadata
    end
  end
end
