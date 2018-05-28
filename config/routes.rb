Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :users
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
    collection do
      get :list
    end
  end
  resources :real_estate_requirements
  resources :classified_categories
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to =>'home#index'
  match "/cards"=>"home#feeds", via: [:get],:as=>"cards"
  match "/services"=>"home#services", via: [:get]
  match "/about_us"=>"home#about_us", via: [:get]
  match "/contact_us"=>"home#contact_us", via: [:get]
  match "/admin_dashboard"=>"admin#index",via: [:get],:as=>"admin_dashboard"
  match "/mangalore-rent-real-estate"=>"home#real_estate",via: [:get],:as=>"real_estate"
  match "/market_reports",:to=>"home#reports",:via=>[:get],:as=>"market_reports"
  match "/download_market_report",:to=>"home#download_market_price",:via=>[:get],:as=>"download_market_report"
end
