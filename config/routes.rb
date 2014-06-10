SampleApp::Application.routes.draw do

  resources :playlists do
    collection { post :sort }
  end

  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :sessions
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :static_pages
  resources :searches

  root to: 'static_pages#home'

  get "search/index"

  match '/signup',   to: 'users#new'
  match '/signin',   to: 'sessions#new'
  match '/signout',  to: 'sessions#destroy', via: :delete

  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'

  match "/auth/:provider/callback" => "sessions#createomni"
  match "/signoutomni" => "sessions#destroyomni", as: :signoutomni

  post '/ajax/send_vid_data', to: 'searches#send_vid_data'

  match '/search_to_list', to: 'videos#search_to_list', :as => :search_to_list
  match '/display_list_vids', to: 'videos#display_list_vids', :as => :display_list_vids
  match '/display_other_vids', to: 'videos#display_other_vids', :as => :display_other_vids
  match '/set_main_vid', to: 'videos#set_main_vid', :as => :set_main_vid
  match '/delete_vid', to: 'videos#delete_vid', :as => :delete_vid

  match '/transfer_list', to: 'playlists#transfer_list'
  match '/transfer_vid', to: 'videos#transfer_vid'

  match '/update_vid', to: 'videos#update_vid'
  match '/update_play', to: 'playlists#update_play'

  match '/like', to: 'playlists#like'
  match '/dislike', to: 'playlists#dislike'

  resources :videos do
    collection { post :sort }
  end

  match '/search_playlists',   to: 'playlists#index'
  match '/autocomplete_list', to: 'playlists#autocomplete_list'
  
  match '/fbpic', to: 'profiles#fb_picture'
  match '/download', to: 'videos#download'
  end