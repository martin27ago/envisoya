class HomeController < ApplicationController
  def login
    if !current_user.nil?
      redirect_to shippings_path
    else
      flash[:notice] = ''
    end

  end
end
