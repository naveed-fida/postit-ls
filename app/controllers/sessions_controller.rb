class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.where(username: params[:username]).first
    if user && user.authenticate(params[:password])
      if user.two_factor_auth?
        user.generate_pin!
        session[:obscured_phone] = user.obscured_phone
        redirect_to pin_path
      else
        login_user!(user)
      end
    else
      flash[:error] = 'Incorrect username or password'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = 'You have been logged out'
    redirect_to root_path
  end

  def pin
    access_denied if !session[:obscured_phone]
    if request.post?
      user = User.find_by pin: params[:pin]
      if user
        login_with_pin!(user)
      else
        flash[:error] = 'You entered the wrong PIN. Try again'
        redirect_to pin_path
      end
    else
      @obscured_phone = session[:obscured_phone]
    end
  end

  private
  def login_user!(user)
    flash[:notice] = "Welcome, #{user.username}!"
    session[:user_id] = user.id
    redirect_to root_path
  end

  def login_with_pin!(user)
    user.remove_pin!
    session.delete(:obscured_phone)
    login_user!(user)
  end
end
