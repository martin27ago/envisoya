class HomeController < ApplicationController
  def login
    Loghelper.Log 'info', 'message'
    if !current_user.nil?
      redirect_to shippings_path
    else
      flash[:notice] = ''
    end

  end
end
