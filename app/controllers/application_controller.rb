class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :current_delivery

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_delivery
    @current_delivery ||= Delivery.find(session[:delivery_id]) if session[:delivery_id]
  end

  def deliveriesJson
    @deliveries = Delivery.all
    render :json => @deliveries
  end

  def healthCheck
    Cost.all
    render :json => {:ok => true}
  end
end
