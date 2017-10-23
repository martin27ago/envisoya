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

=begin
  def current_admin
    @current_admin ||= User.find(session[:user_id] && name[:"admin"]) if session[:user_id]
  end
=end
end
