class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    Comment.create(user_id: current_user.id, post_id: params[:id], content: params[:input_comment])
    redirect_to "/posts/show/" + params[:id]
  end
end
