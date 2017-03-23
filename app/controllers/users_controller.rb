class UsersController < ApplicationController
  before_action :set_user, except: [:new, :create]
  before_action :require_same_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def show;  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Welcome #{@user.username}! You're now registered & logged In."
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit;  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Your profile has been changed"
      redirect_to user_path
    else
      flash[:error] = "Could not update your profile"
      render 'edit'
    end
  end

  private
  def set_user
    @user = User.find_by slug: params[:id]
  end

  def require_same_user
    if @user != current_user
      flash[:error] = "You dont't have access to requested page"
      redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit(:username, :password)
  end
end