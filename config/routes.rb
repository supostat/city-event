TheCityEvents::Application.routes.draw do

  #Push authentication failures to this page
  get 'auth/failure'=> 'application#failure',:as => :failure

  post "webhooks/createCityUser"
  post "webhooks/createFamilyMember"



  resources :city_users do
    get :autocomplete_for_city_user_full_name, :on => :collection
    #get :autocomplete_for_city_user_home_page, :on => :collection
  end

  resources :events do
    member do
      get 'register'
    end
  end

  resources :registrations do
    member do
      get 'summary'
    end
  end

  namespace :admin do
    resources :events
    resources :coupons
    get 'reports/summary/:id' => 'reports#summary',:as => :summary
    get 'reports/detail/:id' => 'reports#detail', :as => :detail

  end

  get  "/admin" => "admin/events#index"



  match "adminLogin" => "sessions#adminLogin",via: [:post]
  match "clientLogin" => "sessions#clientLogin",via: [:get,:post]

  match '/safari_cookie', to: 'sessions#safari_cookie' ,via: [:get,:post]

  match "/auth/:provider/callback" => "sessions#create",via: [:get]
  match "/signout" => "sessions#destroy", :as => :signo,via: [:get]

  match "registrations/verify_coupon" => "registrations#verify_coupon" ,via: [:post]

  match "registrations/redeem_coupon" => "registrations#redeem_coupon" ,via: [:post]

  match "/processfeed" => "datafeeds#parsefeed",via: [:post]


  match "upcoming-events" => "home#upcoming" , :as => "upcoming" ,via: [:get,:post]

  match "registration/:event_id" => "home#registration" , :as => "event_registration" ,via: [:get,:post]

  match "registration/:id/summary" => "home#summary" , :as => "event_registration_summary" ,via: [:get,:post]

  match "complete" => "home#create" , :as => "complete_registration" ,via: [:post]

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  post "/" => "home#index"
  # You can have the root of your site routed with "root"
  root 'home#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
