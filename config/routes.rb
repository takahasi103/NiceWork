Rails.application.routes.draw do
  get "search" => "searches#search"
  resources :notifications, only: [:index]
  #管理者側
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: 'admin/sessions'
  }
  namespace :admin do
    resources :users, only: [:index, :show, :destroy]
    resources :posts, only: [:index, :show, :destroy]
    resources :comments, only: [:destroy]
  end
  
  #ユーザー側
  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
    get 'users/sign_in', to: 'public/homes#top'
  end
  
  devise_for :users,skip: [:passwords], controllers: {
    registrations: 'public/registrations',
    sessions: 'public/sessions'
  }
  
  
  scope module: :public do
    root 'homes#top'
    
    resources :users, only: [:index, :show, :update, :destroy], param: :account_name do
      resource :relationships, only: [:create, :destroy]
      get "likes" => "users#likes"
      get "followings" => "relationships#followings", as: "followings"
      get "followers" => "relationships#followers", as: "followers"
    end
    
    resources :posts, only: [:create, :index, :show, :update, :destroy] do
      member do
        delete 'clear_image', to: 'posts#clear_image'
      end
      resource :favorites, only: [:create] do
        patch 'cancel' => 'favorites#cancel'
        patch 'apply' => 'favorites#apply'
      end
      resources :comments, only: [:create, :destroy]
    end
  end

  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
