Rails.application.routes.draw do
  #管理者側
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: 'admin/sessions'
  }
  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update, :destroy]
    resources :posts, only: [:index, :show]
    resources :comments, only: [:destroy]
  end
  
  #ユーザー側
  devise_for :users,skip: [:passwords], controllers: {
    registrations: 'public/registrations',
    sessions: 'public/sessions'
  }
  scope module: :public do
    root 'homes#top'
    
    resources :users, only: [:show, :edit, :update, :destroy], param: :account_name do
      get 'withdraw' => 'users#withdraw'
      resource :relationships, only: [:create, :destroy]
      get "followings" => "relationships#followings", as: "followings"
      get "followers" => "relationships#followers", as: "followers"
    end
    
    resources :posts, only: [:new, :index, :show, :edit, :update, :destroy] do
      resource :favorites, only: [:create] do
        patch 'cancel' => 'favorites#cancel'
        patch 'apply' => 'favorites#apply'
      end
      resources :comments, only: [:create, :destroy]
    end
  end

  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
