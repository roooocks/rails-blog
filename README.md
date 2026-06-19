# Ruby on Rails 8 블로그 v2
CRUD 블로그 예제로, v1을 수정하면서 계정/댓글 기능을 추가했습니다.

## v1 => v2 수정 사항
- 게시글 날짜/시간 추가
- 게시글 최신순으로 정렬
- 게시글 모든 영역에 bootstrap 적용

## v1 => v2 기능 추가
- Devise gem으로 `계정 기능 추가`
- 계정 기능을 활용해 `로그인/회원가입/로그아웃 기능 추가`
- 회원이 아닐 경우 `게시글 관련 기능(추가/수정/삭제) 제한`
- 게시글 내용
![게시글 내용](/readmeimage/게시글%20내용.png)
- 게시글 메인 화면 (로그인 안한 화면)
![게시글 로그인 안한 메인화면](/readmeimage/게시글%20메인%20화면.png)


## 사용해본 기능들

### ENV
  - 적용
  ```bash
  # ~/.bashrc or ~/.zshrc
  export DB_HOST="127.0.0.1"

  # 환경변수 적용
  source ~/.bashrc (or ~/.zshrc)
  ```
  - 호출 : `ENV.fetch("DB_HOST")`
    - 좀 더 정확히는 DB_HOST가 없을 때 오류 발생
### DB
  - 기본 DB는 SQLite3이므로 다른걸 원한다면 프로젝트 생성할 때 `rails new [project_name] -d [database]` 사용
  - `config/database.yml`에 DB 환경 설정
  - 테이블 생성을 위한 model, migrate 파일 생성
    - `rails g model TABLE_NAME column1:type column2:type ...`
  - 관련 rails 명령어 활용
    - `bin/rails db:create`(DB 생성)
    - `bin/rails db:migrate`(최근 테이블 생성)
    - `bin/rails db:rollback`(migration 되돌리기)
    - `bin/rails db:seed`(더미/초기 데이터 삽입)
    - `bin/rails db:drop`(DB 날리기)
    - `bin/rails db:reset`(DB 초기화/drop,create,migrate,seed 순서로 실행)
  - 의존 관계
    - 명령어를 활용해 테이블을 생성하는 프레임워크 특성상 `references` 사용
      - `bin/rails g model TABLE_NAME column1:type column2:references`
    - cascade 관계는 migration 파일에서 따로 추가
    ```rb
    class CreatePosts < ActiveRecord::Migration[8.1]
        def change
            create_table :posts do |t|
            # 여기서 사용하는 cascade는 수동으로 추가
            t.references :user, null: false, foreign_key: { on_delete: :cascade }
            t.string :title
            t.text :content

            t.timestamps
            end
        end
    end
    ```
    - 클래스 간 관계의 방향을 표현하는 매크로 사용
      - v2에서는 model 파일에서만 사용
      - `belongs_to` : 나는 ~에 속한다
      - `has_many` : 나는 여러 개를 가진다
      - `has_one` : 나는 하나를 가진다
  - 기초적인 쿼리문 작성해보기
    - `Post.all` : SELECT * FROM posts
    - `Post.find(id)` : primary key 기준 단일 조회
    - `Post.select(:title, :content)` : 일부 컬러만 조회
    - `Post.includes(:user)` : 연관 데이터 미리 로딩(N+1 쿼리 방지)
    - 체이닝 가능

### Routing
  - config/routes.rb
  ```rb
    Rails.application.routes.draw do
        # routes는 순서가 중요하다. 맨 아래쪽을 먼저 본다고 하니 작성할 때 주의
        devise_for :users

        root "posts#index" # main

        get "posts/show/:id", to: "posts#show"
        get "posts/new"
        get "posts/edit/:id", to: "posts#edit"
        # 옛 방식은 "=>" 를 사용
        get "posts/destroy/:id", to: "posts#destroy"

        post "posts/create"
        post "posts/update/:id", to: "posts#update"

        post "comments/create/:id", to: "comments#create"
    end
  ```

### Devise
  - `bin/rails g devise User` => `bin/rails db:migrate` / 사용자 관련 환경 설정
  - `config/routes.rb`에서 `devise_for :users`추가되면 준비 완료
  - 페이지는 기본 지원하는 `sign_in`(로그인), `sign_out`(로그아웃), `sign_up`(회원가입)만 사용
  - 전용 메서드
    - `current_user` : 현재 로그인한 계정 정보
    - `user_signed_in?` : 로그인한 사용자인가?
    - `before_action :authenticate_user!` : controller 단에서 session 확인 후 로그인 안할 시 `sign_in` 페이지로 전달
  - `bin/rails g devise:views`로 view 파일의 UI 커스텀
  - devise에서 사용하는 오류 locales 파일 사용하여 `flash[:alert]` 방식으로 띄워보기
  ```erb
    <%# config/locales/devise.ko.yml 추가 / 당장은 en파일을 해석만 해서 붙여놓음 %>
    <%# app/views/devise/confirmations/new.html.erb %>
    <div class="vh-100 d-flex flex-column justify-content-center align-items-center bg-secondary-subtle">
        <div class="card shadow-sm border-0" style="min-width: 360px; max-width: 420px; width: 100%;">
            <div class="card-body p-4">
            <h3 class="text-center mb-4 fw-semibold">Log in</h3>

            # flash[:alert]에 저장된 뭔가가 있다면 그걸 출력한다.
            <% if flash[:alert] %>
                <div class="alert alert-danger">
                <%= flash[:alert] %>
                </div>
            <% end %>

            <%= form_for(resource, as: resource_name, url: session_path(resource_name)) do |f| %>
                <div class="field mb-3">
                <%= f.label :email, class: "form-label" %>
                <%= f.email_field :email,
                    autofocus: true,
                    autocomplete: "email",
                    class: "form-control form-control-lg" %>
                </div>
    ...(생략)...
  ```

### Rails 기본 메서드 사용
  - `redirect_to "/"` : "/"로 이동
  - `params[:name]` : "파라미터 가져오기"
  - `flash[:name]` : 다음 요청까지 유지되는 일회성 사용자 메시지 저장
  - `<%= hidden_field_tag :authenticity_token, form_authenticity_token %>` : Rails용 CSRF 방어