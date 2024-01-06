Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
  }
  root to: 'homes#top'
  get 'homes/mypage'
  resources :users, only: [:index, :show, :edit, :update]
  get 'chat/:id' => 'chats#show', as: 'chat'
  resources :chats, only: [:create]
  get 'homes/about' => 'homes#about', as: 'about'
  resources :post_images, only: [:new, :create, :index, :show, :destroy] do
    resources :post_comments, only: [:create]
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
