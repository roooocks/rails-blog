Rails.application.routes.draw do
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

  get "posts/new"
  post "posts/create"
  # posts#show => posts 컨트롤러의 show 액션
  get "posts/show/:id" => "posts#show"
  # 화살표는 옛 스타일, 현재 권장 방식은 아래와 같다.
  # get "/posts/edit/:id", to: "posts#edit"
  # 만약 as "name"을 추가로 지정하면 나중에 name_path(param) 방식으로 /posts/edit/param이 가능하다.
  get "posts/edit/:id" => "posts#edit"
  post "posts/update/:id" => "posts#update"

  # 삭제가 GET인데, 사실 JWT를 써서 검증을 한번 거쳐야 한다.
  # 우선 이 예제에서는 매우 간단한 구조만을 사용했기에, 복습하면서 최신 방식으로 바꿔보자.
  get "/posts/destory/:id", to: "posts#destory"
end
