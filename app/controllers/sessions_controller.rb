class SessionsController < ApplicationController
  def create
    type = request.env["omniauth.params"]['type']
    if(type=='user')
      user = User.from_omniauth(request.env["omniauth.auth"])
      session[:user_id] = user.id
      redirect_to user_path(user.id)+'/edit'
    else
      delivery = Delivery.from_omniauth(request.env["omniauth.auth"])
      session[:delivery_id] = delivery.id
      redirect_to delivery_path(delivery.id)+'/edit'
    end

  end

  def signin
    user = User.signin(params[:email][:email], params[:password][:password])
    if(user.nil?)
      delivery = Delivery.signin(params[:email][:email], params[:password][:password])
      if(delivery.nil?)
        flash[:notice]= "Invalido usuario y/o contrasena"
        redirect_to home_login_url
      else
        session[:delivery_id] = delivery.id
        redirect_to delivery_path(delivery.id)+'/edit'
      end
    else
      session[:user_id] = user.id
      if(user.admin == true)
        redirect_to deliveries_url
      else
        redirect_to user_path(user.id)+'/edit'
      end
    end
  end

  def destroy
    session[:user_id] = nil
    session[:delivery_id] = nil
    redirect_to home_login_path
  end
end
