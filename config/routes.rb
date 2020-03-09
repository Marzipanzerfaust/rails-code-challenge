Rails.application.routes.draw do
  get 'home/index'
  root "home#index"
  resources :articles
  devise_for :users

  scope :admin do
    resources :users
  end
end
