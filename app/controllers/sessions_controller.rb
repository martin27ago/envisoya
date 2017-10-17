class SessionsController < ApplicationController
  def create
    type = request.env["omniauth.params"]['type']
    if(type=='user')
      user = User.from_omniauth(request.env["omniauth.auth"])
    end

    session[:user_id] = user.id
    redirect_to user_path(user.id)+'/edit'
  end

  def signin
    user = User.signin(params[:email][:email], params[:password][:password])
    if(user.nil?)
      flash[:notice]= "Invalid username o password"
      redirect_to home_login_url
    else
      session[:user_id] = user.id
      redirect_to user_path(user.id)+'/edit'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to home_login_path
  end
end
