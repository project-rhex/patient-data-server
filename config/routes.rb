HdataServer::Application.routes.draw do

  ##
  resources :ref_consult_requests
  match "ref_consult_requests/new/:id" => "ref_consult_requests#new", :as => :new_ref_consult_request_patient, :method => :get

  resources :ref_consult_summaries

  resources :clients

  devise_for :users, :controllers => {:registrations => 'registrations'}

  resources :users

  resources :notifications

  resources :notify_configs

  get "audit_review/index"

  get "audit_review/show"

  match '/auth/:provider/callback' => 'authentications#create'
  match '/auth/failure' => 'authentications#failure'

  mount Devise::Oauth2Providable::Engine => '/oauth2'
  resources :authentications

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
  match "audit_logs" => "audit_logs#index", :as => "audit_logs"

  resources :records do
    resources :c32
  end

  #
  match "records/:id" => "records#show", :as => "root_feed", :format => :atom, :via=> :get
  match "records/:id/root.xml" => "records#root", :as => :root_document, :format => :xml, :method => :get
  match "records/:id" => "records#options", :as => :root_options, :via => :options
  match "records/:record_id/:section" => "entries#index", :as => :section_feed, :format => :atom, :via => :get
  match "records/:record_id/:section" => "entries#index", :as => :section, :via => :get
  match "records/:record_id/:section/:id" => "entries#show", :as => :section_document, :via => :get
  match "records/:record_id/:section" => "entries#create", :as => :new_section_document, :via => :post
  match "records/:record_id/:section/:id" => "entries#update", :as => :update_section_document, :via => :put
  match "records/:record_id/:section/:id" => "entries#delete", :as => :delete_section_document, :via => :delete

  root :to =>  "records#index"


  match "users/:id/make_admin"   => "users#make_admin",   :method => :get
  match "users/:id/remove_admin" => "users#remove_admin", :method => :get
  match "notify_configs_all/:all" => "notify_configs#index", :method => :get, :as => :notify_configs_all
  match "notifications_all/:all"  => "notifications#index", :method => :get, :as => :notifications_all
  
  #mount the oauth2 devise provider

  match "open_id/:action" => "open_id#:action"
  
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id(.:format)))'

  ## static content route
  match ':action' => 'static#:action'


end
