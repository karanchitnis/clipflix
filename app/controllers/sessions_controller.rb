class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.authenticate(params[:session][:email], params[:session][:password])
    #session[:user_id] = user.id
      
    if user
      #sign_in user
      session[:user_id] = user.id
      redirect_to root_url
    else
      flash.now[:error] = "Invalid email/password combination"
      render 'new'
    end
  end

  def createomni
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    #session[:user_id] = user.id
    if user
      #sign_in user
      session[:user_id] = user.id
      redirect_to root_url
    else
      flash.now[:error] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    #sign_out
    session[:user_id] = nil
    redirect_to root_path, :notice => "Signed out!"
  end

  def destroyomni
    #sign_out
    session[:user_id] = nil
    redirect_to root_path, :notice => "Signed out!" 
  end
end
