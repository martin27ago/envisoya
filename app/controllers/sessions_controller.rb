class SessionsController < ApplicationController
  def createFacebook
    user = User.from_omniauth(request.env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to user_path(user.id)+'/edit'
  end

  def signin
    user = User.signin(params[:mail][:mail], params[:password][:password])
    session[:user_id] = user.id
    redirect_to user_path(user.id)+'/edit'
  end

  def signout
    session[:user_id] = nil
    redirect_to home_login_path
  end
end
