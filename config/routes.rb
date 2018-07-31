Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  resources :photos do
    collection do
      # Routes for visitors
      get :new_image
      post :create_image
    end

    member do
      get :edit_metadata
      get :update_metadata
      get :download

      # Routes for visitors
      get :edit_metadata_image
      get :update_metadata_image
      get :download_image
      delete :delete_image
    end
  end
end
