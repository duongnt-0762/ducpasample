class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :destroy]
  before_action :check_logged_in, only: [:new]
  before_action :find_id, only: [:correct_user, :show, :edit, :update, :destroy]
  before_action :correct_user,only: [:edit, :update]
  before_action :admin_user,only: :destroy

  def index
    @users = User.paginate(page: params[:page])
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

  def new
    @user = User.new
  end

  def show
    @microposts = @user.microposts.order_by_time.paginate(page: params[:page])
  end

  def edit

  end

  def destroy
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def update
      if @user.update(user_params)
        flash[:success] = "Profile updated"
        redirect_to @user
       # Handle a successful update.
      else
        render :edit
      end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Before filters
  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
      
    end
  end

  def check_logged_in
    if logged_in?
      flash[:danger] = "Please sign out your account before sign in another account !"
      redirect_to root_path
    end 
  end 

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def find_id
    @user = User.find_by id:params[:id]
    if @user.nil?
      flash[:danger] = "User is not exist !"
      redirect_to root_path
    end
  end

  def correct_user
     if  !current_user.current_user?(@user)
      flash[:danger] = "Error: Sorry, You can't edit another account !"
      redirect_to @user
     end
  end

end
