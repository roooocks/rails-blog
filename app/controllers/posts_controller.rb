class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
  end

  def create
    Post.create(title: params[:post_title], context: params[:post_content])
    redirect_to "/"
  end

  def show
    @posts = Post.find(params[:id])
  end

  def edit
    @posts = Post.find(params[:id])
  end

  def update
    @posts = Post.find(params[:id])
    @posts.update(title: params[:post_title], context: params[:post_content])

    redirect_to "/posts/show/" + params[:id]
  end

  def destroy
    @posts = Post.find(params[:id])
    @posts.destory

    redirect_to "/"
  end
end
