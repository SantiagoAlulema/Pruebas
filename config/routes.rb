Rails.application.routes.draw do
  resources :formularios do
    collection do
      get :search
    end
    member do
      get :download
      get :download_later
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
