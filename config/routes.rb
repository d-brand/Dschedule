Rails.application.routes.draw do
  get 'top', to: 'home#top', as: :top
  root to:'home#index'
  namespace :admin do
    resources :users
  end
  #root 'schedules#show'
  # get "/" => "schedules#index"
  get "schedules/kiyaku" => "schedules#kiyaku"
  get 'login', to: 'home#index'
  resources :team
  resources :answers
  resources :schedules
  devise_for :users
  
  # お問い合わせフォーム
  resources :contacts, only: [:new, :create]
  post 'contacts/confirm', to: 'contacts#confirm', as: 'confirm'
  post 'contacts/back', to: 'contacts#back', as: 'back'
  get 'done', to: 'contacts#done', as: 'done'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
