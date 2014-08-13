Rails.application.routes.draw do
  resources :card_activity, only: [:create]
  resources :subscriptions
end
