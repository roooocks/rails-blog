class PostsController < ApplicationController
  # before_action :authenticate_user! # 이쪽 페이지 전부 막기
  before_action :authenticate_user!, except: [ :index, :show ] # index, show 제외하고 전부 막기

  def index
    @posts = Post.includes(:user, :comments).order(created_at: :desc)
  end

  def show
    # includes는 미리 데이터 가져오기 기능이다.
    # 안하면 가져올 때 마다 쿼리를 때려버린다.

    # @post = Post.find(params[:id])
    @post = Post.includes(comments: :user).find(params[:id]) # Post > Comments > User
  end

  def new
  end

  def create
    # Devise Gem에서는 "current_user.posts.create(post_params)" 방식이면 한번에 작동하게 된다.
    Post.create(user_id: current_user.id, title: params[:input_title], content: params[:input_content])
    redirect_to "/"
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    Post.update(title: params[:input_title], content: params[:input_content])

    redirect_to "/posts/show/" + params[:id]
  end

  def destroy
    @post = Post.find(params[:id])

    # 1. not if
    # 2. flash[:alert]를 사용해야함. 지금은 applicaiton에서 공통적으로 관리한다는 것만 알아두자
    #   - 그리고 alert 이런건 내가 원하는걸로 만들어두면 된다고 한다.
    unless user_signed_in? && current_user == @post.user
      redirect_to "/", alert: "권한 없음"
      return
    end

    @post.destroy

    redirect_to "/"
  end
end
