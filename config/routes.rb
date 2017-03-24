PostitTemplate::Application.routes.draw do
  root to: 'posts#index'

  get '/register' => 'users#new', as: 'register'
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  get '/pin' => 'sessions#pin'
  post '/pin' => 'sessions#pin'

  resources :posts, except: [:destroy] do
    member do
      post :vote
    end
    resources :comments, only: [:create], shallow: true do
      member do
        post :vote
      end
    end
  end

  resources :categories, only: [:new, :create, :show]
  resources :users, only: [:create, :show, :edit, :update]
end
