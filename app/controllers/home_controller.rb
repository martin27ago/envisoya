class HomeController < ApplicationController
  def login
    if !current_user.nil?
      redirect_to edit_user_path(current_user)
    end

  end
end
