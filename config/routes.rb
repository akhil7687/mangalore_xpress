Rails.application.routes.draw do
  resources :service_providers
  resources :feeds
  resources :service_categories do
    collection do
      get :autocomplete
    end
    resources :enquiries
  end
  resources :enquiries
  resources :classifieds do
    resources :enquiries
    member do
      get :enquire
    end
  end
  resources :classified_categories
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to =>'home#index'
  match "/cards"=>"home#feeds", via: [:get]
  match "/services"=>"home#services", via: [:get]
  match "/about_us"=>"home#about_us", via: [:get]
  match "/contact_us"=>"home#contact_us", via: [:get]
end
