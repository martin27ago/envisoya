class UsersController < ApplicationController

  before_action :require_login, only: [:show, :edit]
  before_action :is_log, only: [:new]

  def require_login
    if current_user.nil?
      flash[:notice] = "Tienes que estar logeado"
      redirect_to home_login_url
    end
  end

  def is_log
    if !current_user.nil? or !current_delivery.nil?
      flash[:notice] = "No podes registrar nuevo usuario si estas logeado"
      redirect_to home_login_url
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "#{@user.name} borrado."
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
    userFrom = params[:user][:userFrom]
    cedula = user_params[:document]
    image = delivery_params[:image]
    if(!CiUY.validate(cedula)or image.nil?)
      if(!CiUY.validate(document))
        flash[:notice] = "Documento no verificable"
      else
        flash[:notice] = "Falta la foto"
      end
      render '/users/new'
    else
      begin
      @user = User.create!(user_params)
      rescue ActiveRecord::RecordInvalid => invalid
        if (@user.nil?)
          flash[:notice] = invalid.message
          render '/users/new'
        else
          flash[:notice] = "#{@user.name} te registraste con exito."
          if(userFrom!='')
            Discount.ManageDiscount @user, userFrom
          end
          session[:user_id] = @user.id
          redirect_to shippings_path
        end
      end
    end
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