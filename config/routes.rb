JustEvents::Application.routes.draw do
	get "case_files/new"
	get "sessions/new"

	resources :users
	resources :petitions
	resources :casefiles
	resources :sessions, :only => [:new, :create, :destroy]
	resources :microposts
	resources :investigations
	resources :todoitems, :only => [:new, :create, :destroy, :update]
	resources :tags, :only => [:create, :destroy]

	match '/todoitems/:id/update' => 'todoitems#update', :as=>'update_task'
	match '/current_events' => 'pages#current_events'
	match '/casefiles/:id/edit' => 'casefiles#edit', :as=>'edit_case'
	match '/todoitems/:id/delete' => 'todoitems#destroy', :as=>'delete_task'
	match '/casefiles/:id/delete' => 'casefiles#destroy', :as=>'delete_casefile'
	match '/petitions/:id/delete' => 'petitions#destroy', :as=>'delete_petition'
	match '/lastweek/' => 'pages#last_week', :as=>'last_week'
	match '/investigations/:id/update' => 'investigations#update_status', :as=>'update_investigation'
	match '/petitions/:id/resend_petition' => 'petitions#resend_petition', :as=>'resend_petition'
  
	match '/signin', :to => 'sessions#new'
	match '/signout', :to => 'sessions#destroy'
	match '/help', :to => 'pages#help'
	match '/users', :to => 'pages#users'
	match '/posts', :to => 'pages#posts'

	match '/signup', :to => 'users#new' 
	match '/reports', :to => 'pages#reports'
	match '/custom_report', :to => 'pages#custom_report'
	match '/csv', :to => 'pages#export_to_csv'
	match '/calls', :to => 'pages#calls'
	match '/cases', :to => 'pages#cases'
	match '/todoitems', :to => 'pages#todos'
	match '/todo', :to=>'pages#todos'
	match '/fulldisposition', :to=>'pages#fulldisposition'
	match '/newcase', :to => 'casefiles#new', :as=>'new_case'
	match '/post', :to => 'pages#post'
	match '/newinvestigation', :to => 'investigations#new', :as=>'new_investigation'
  
  root :to => 'pages#home'
end


