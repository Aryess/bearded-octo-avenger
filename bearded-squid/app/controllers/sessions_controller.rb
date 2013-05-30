class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if(user && user.authenticate(params[:session][:password]))
      sign_in user
      flash[:success] = "Welcome back"
      redirect_to user
    else
      flash.now[:error] = "Invalid"
      render 'new'
    end
  end
  
  def destroy
    sign_out
    flash[:success] = "See you soon"
    redirect_to home_path
  end
end
