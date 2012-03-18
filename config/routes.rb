JustEvents::Application.routes.draw do
  get "case_files/new"
  

  get "sessions/new"

resources :users
resources :casefiles
  resources :sessions, :only => [:new, :create, :destroy]
  resources :microposts
  resources :todoitems, :only => [:new, :create, :destroy, :update]
  resources :tags, :only => [:create, :destroy]

   match '/todoitems/:id/update' => 'todoitems#update', :as=>'complete_task'
   match '/casefiles/:id/edit' => 'casefiles#edit', :as=>'edit_case'
   match '/todoitems/:id/delete' => 'todoitems#destroy', :as=>'delete_task'
   match '/casefiles/:id/delete' => 'casefiles#destroy', :as=>'delete_casefile'
 
  
  match '/signin', :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  match '/help', :to => 'pages#help'
  match '/users', :to => 'pages#users'
  match '/posts', :to => 'pages#posts'
  match '/signup', :to => 'users#new' 
  match '/reports', :to => 'pages#reports'
  match '/csv', :to => 'pages#export_to_csv'
  match '/calls', :to => 'pages#calls'
  match '/cases', :to => 'pages#cases'
  match '/todoitems', :to => 'pages#todos'
  match '/todo', :to=>'pages#todos'
  
  
  root :to => 'pages#home'

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


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
