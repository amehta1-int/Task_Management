Rails.application.routes.draw do
  get "home/index"
  resources :tasks

  get  "/login",  to: "sessions#new"
  post "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get  "/signup", to: "users#new"
  post "/signup", to: "users#create"

  root to: "home#index"
end
