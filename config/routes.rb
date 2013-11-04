# -*- encoding : utf-8 -*-
Contacal::Application.routes.draw do

  devise_for :users, :controllers => { :registrations => "registrations" }
  resources :foods, :only => [:new, :create]
  resources :user_friends, :only => [:new, :create]
  resources :user_foods, :only => [:create, :destroy, :update]
  match 'kcal_limit' => 'dashboard#update_kcal_limit', :as => :kcal_limit, :via => :put
  match 'user_weight' => 'dashboard#update_user_weight', :as => :user_weight, :via => :put
  match 'report' => 'dashboard#report', :as => :report
  match 'weight_report' => 'dashboard#weight_report', :as => :weight_report
  match 'autocomplete_food_name', :to => 'dashboard#autocomplete_food_name', :as => :autocomplete_food_name
  match 'users/confirm', :to => 'confirmation#index', :as => :user_confirm
  match ':year/:month/:day' => "dashboard#index", :as => :dashboard, :constraints => { :year => /\d{4}/, :month => /\d{2}/, :day => /\d{2}/ }
  match 'authenticate', :to => 'dashboard#authenticate'
  root :to => "dashboard#index"       
  authenticate :user do
    devise_scope :user do
      match 'payment' => 'registrations#payment', :as => :payment   
    end
  end 
  


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
