Rails.application.routes.draw do
  devise_for :users
  resources :alerts

  resources :bikes

  root "alerts#index"
end
