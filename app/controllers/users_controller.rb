class UsersController < ApplicationController

  def edit
   @user = User.find params[:id]
  end

  def new
    @user = User.new
  end

  def update
    @user = User.find params[:id]
    @user.update_attributes!(user_params)
    flash[:notice] = "#{@user.name} se actualizo correctamente."
    redirect_to user_path(@user)
  end

  def show
    id = params[:id]
    @user = User.find(id)
    resolve_format @user
  end

  def create
    @user = User.create!(user_params)
    flash[:notice] = "#{@user.name} te registraste con exito."
    redirect_to user_path(user.id)+'/edit'
  end

  def users
    # @clients = User.where(User.client)
    @users = User.All
    resolve_format @users
  end

  def user_params
    params.require(:user).permit(:name, :surname, :mail, :document, :password)
  end

  def resolve_format(obj)
    respond_to do |format|
      format.html
      format.xml { render :xml => obj }
      format.json { render :json => obj }
    end
  end
end