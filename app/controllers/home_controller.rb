class HomeController < ApplicationController
  def login
    if !current_user.nil? or !current_delivery.nil?
      redirect_to shippings_path
    else
      flash[:notice] = ''
    end

  end
end
