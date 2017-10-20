class UsersController < ApplicationController

  #before_action :require_login, only: [:show]

  def require_login
    if @current_user.nil?
      flash[:notice] = "Tienes que estar logeado"
      redirect_to home_login_url
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "#{@user.name}' borrado."
    redirect_to users_path
  end

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
    @user.admin = false
    @user = User.create!(user_params)
    flash[:notice] = "#{@user.name} te registraste con exito."
    redirect_to user_path(@user.id)+'/edit'
  end

  def index
    # @clients = User.where(User.client)
    @users = User.all
    resolve_format @users
  end

  def user_params
    params.require(:user).permit(:name, :surname, :email, :document, :password, :image)
  end

  def resolve_format(obj)
    respond_to do |format|
      format.html
      format.xml { render :xml => obj }
      format.json { render :json => obj }
    end
  end
end