Twopickles::Application.routes.draw do


  get "post_category_relationships/create"

  get "post_category_relationships/destroy"

  # customer activation routes
  match "/users/activate/(:id/(:activation_hash))", 
                                            :to => 'users#activate'

  match "/posts/activate/(:id/(:activation_hash))", 
                                            :to => 'posts#activate'

  match "/communities/activate/(:id/)", 
                                            :to => 'communities#activate'

  # load resources for the users
  resources :users do
    resources :posts, :only => [:show, :index]
    resources :trades, :only => [:show, :index]
    resources :communities, :only => [:show, :index]
  end
  resources :sessions, :only => [:new, :create, :destroy]
  resources :posts do
    resources :trades, :only => [:show, :create, :destroy]
  end
  resources :communities
  resources :user_community_relationships, :only => [:create, :destroy]
  resources :states, :only => [:index, :show]

  #custom page for searching for posts
  match '/search', :to => 'posts#search'

  # custom page for registering new users
  match '/register',  :to => 'users#new'

  # custom pages for signing in and signing out
  match '/signin',    :to => 'sessions#new'
  match '/signout',   :to => 'sessions#destroy'

  # static page shortcuts
  match '/about',     :to => 'pages#about'
  match '/userguide', :to => 'pages#userguide'
  match '/faq',       :to => 'pages#faq'
  match '/safety',    :to => 'pages#safety'
  match '/privacy',   :to => 'pages#privacy'
  match '/terms',     :to => 'pages#terms'
  match '/contact',   :to => 'pages#contact'
  
  get "pages/home"
  get "pages/contact"
  get "pages/about"
  get "pages/privacy"
  get "pages/terms"
  get "pages/faq"
  get "pages/userguide"
  get "pages/safety"

  root :to => "pages#home"

end
