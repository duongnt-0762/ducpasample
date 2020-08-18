class UsersController < ApplicationController

  def index
    @users = User.all.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find_by(id: params[:id])
    if @user.nil?
      flash[:danger] = "Can't find this user"
      redirect_to root_path
    end
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
    render :new  
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :dob, :address, :gender, :password, :password_confirmation)
  end

end
