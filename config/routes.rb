Rails.application.routes.draw do
  get 'kiyaku/index'
  get 'top', to: 'home#top', as: :top
  root to:'home#index'
  namespace :admin do
    resources :users
  end
  get 'login', to: 'home#index'
  resources :team
  post 'token_generte', to: 'team#token_generte'
  resources :answers
  scope '/:teamcores_teamname' do
    resources :schedules
  end

  resources :kiyaku
  # registrations_controller.rbを有効にします。
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  
  devise_scope :user do
    post 'users/sign_up/confirm', to: 'users/registrations#confirm'
    get 'users/sign_up/email_notice', to: 'users/registrations#email_notice'
    get 'users/sign_up/complete', to: 'users/registrations#complete'
  end

  get '*path', controller: 'application', action: 'render_404'
end
