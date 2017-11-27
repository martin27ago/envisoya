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

  def healthCheck
    User.all
    health_costs = false
    begin
      health_costs = CostsService.health_check_costs
    rescue
    end
    render :json => {:apiShipping => true, :apiCosts => health_costs}
  end
end
