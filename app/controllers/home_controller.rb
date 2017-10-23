class HomeController < ApplicationController
  def login
    if !current_user.nil?
      redirect_to edit_user_path(current_user)
    else
      flash[:notice] = ''
    end

  end
end
