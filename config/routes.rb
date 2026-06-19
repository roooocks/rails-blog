Rails.application.routes.draw do
  # routes는 순서가 중요하다. 맨 아래쪽을 먼저 본다고 하니 gem 관련 부터 올려두자
  devise_for :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  root "posts#index"

  get "posts/show/:id", to: "posts#show"
  get "posts/new"
  get "posts/edit/:id", to: "posts#edit"
  get "posts/destroy/:id", to: "posts#destroy"

  post "posts/create"
  post "posts/update/:id", to: "posts#update"

  post "comments/create/:id", to: "comments#create"
end
