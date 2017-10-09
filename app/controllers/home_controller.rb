class HomeController < ApplicationController
  def show
    flash[:notice] = "Bienvenido"
  end
end
