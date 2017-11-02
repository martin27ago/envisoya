class SessionsController < ApplicationController
  def create
    type = request.env["omniauth.params"]['type']
    if(type=='user')
      user = User.from_omniauth(request.env["omniauth.auth"])
      session[:user_id] = user.id
      if !user.document.nil?
        redirect_to shippings_path
      else
        redirect_to user_path(user.id)+'/edit'
      end
    else
      delivery = Delivery.from_omniauth(request.env["omniauth.auth"])
      session[:delivery_id] = delivery.id
      if !delivery.document.nil?
        redirect_to shippings_path
      else
        redirect_to delivery_path(delivery.id)+'/edit'
      end
    end

  end

  def signin
    type = params[:autolyse][:autolyse]
    if(type=="true")

      user = User.signin(params[:email][:email], params[:password][:password])
      if(user.nil?)
        flash[:error]= "Invalido usuario y/o contraseña"
        redirect_to home_login_url
      else
        LoggerHelper.Log 'info', 'Usuario '+ user.name+' '+user.surname+ ' inicia sesión'
        session[:user_id] = user.id
        if(user.admin == true)
          LoggerHelper.Log 'info', 'Administrador '+ user.name+' '+user.surname+ ' inicia sesión'
          redirect_to deliveries_url
        else
          redirect_to shippings_path
        end
      end
    else
      delivery = Delivery.signin(params[:email][:email], params[:password][:password])
      if(delivery.nil?)
        flash[:error]= "Invalido usuario y/o contrasena"
        redirect_to home_login_url
      else
        session[:delivery_id] = delivery.id
        LoggerHelper.Log 'info', 'Cadete '+ delivery.name+' '+delivery.surname+ ' inicia session'
        redirect_to shippings_path
      end
    end
  end

  def destroy
    session[:user_id] = nil
    session[:delivery_id] = nil
    redirect_to home_login_path
  end
end
