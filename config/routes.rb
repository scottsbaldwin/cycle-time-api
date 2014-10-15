Rails.application.routes.draw do
  resources :card_activity, only: [:index, :create, :show]
  resources :subscriptions
end
