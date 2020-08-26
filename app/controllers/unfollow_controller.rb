class FollowController < ApplicationController
  before_action :logged_in_user
  before_action :find_user, only: :index

  def index
    @users = @user.follow.paginate page: params[:page]
  end

  def create
    @user = User.find_by id: params[:followed_id]
    unless current_user.following? @user
      current_user.follow @user
      @relationship =
        current_user.active_relationships.find_by followed_id: @user.id
    end
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end

  private
  def find_user
    @user = User.find_by id: params[:user_id]
    unless @user
      flash.now[:danger] = "User not found"
      redirect_to signup_path
    end
  end
end