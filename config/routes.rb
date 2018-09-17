Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :users, controllers: { registrations: 'registrations' }
  resources :service_providers
  resources :feeds do
    collection do
      get :load_feed
    end
  end
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
  resources :ads
  resources :contests
  resources :contest_registrations
  resources :comments
  resources :wall_posts do
    resources :comments
    member do
     get :comment
    end
  end
  devise_scope :user do
    get 'users/profile', to: 'devise/registrations#edit',via: [:get],as: 'profile'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to =>'home#index'
  match "/cards"=>"home#feeds", via: [:get],:as=>"cards"
  match "/articles"=>"home#feeds", via: [:get],:as=>"articles"
  match "/wall"=>"home#wall_post", via: [:get],:as=>"wall"
  match "/services"=>"home#services", via: [:get]
  match "/about_us"=>"home#about_us", via: [:get]
  match "/contact_us"=>"home#contact_us", via: [:get]
  match "/admin_dashboard"=>"admin#index",via: [:get],:as=>"admin_dashboard"
  match "/mangalore-rent-real-estate"=>"home#real_estate",via: [:get],:as=>"real_estate"
  match "/market_reports",:to=>"home#reports",:via=>[:get],:as=>"market_reports"
  match "/download_market_report",:to=>"home#download_market_price",:via=>[:get],:as=>"download_market_report"
  match "/users/update_token"=>"home#update_token",via: [:post]
  match "/users/toggle_subscribe"=>"home#toggle_subscribe",via: [:post]
  match "/home/new_notification"=>"home#new_notification",via: [:get],:as=>"new_notification"
  match "/home/send_notification"=>"home#send_notification",via: [:post],:as=>"send_notification"
  match "/app"=>"home#app",via: [:get]
  match "/member/:id"=>"wall_posts#member",via: [:get],:as=>"member"

  resources :likes
  post '/likes/toggle', to: 'likes#toggle', via:[:post]

end
