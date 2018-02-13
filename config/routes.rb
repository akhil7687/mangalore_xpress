Rails.application.routes.draw do
  resources :service_categories do
    collection do
      get :autocomplete
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to =>'home#index'
end
