class UsersController < ApplicationController

  before_action :require_login, only: [:show, :edit]
  before_action :is_log, only: [:new]
  before_action :admin_login, only: [:index, :destroy]
  before_action :check_doc_and_password, only: [:show]

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

  def admin_login
    if !current_user.nil? and !current_user.admin
      flash[:notice] = "Solo puede ingresar el admin"
      redirect_to home_login_url
    end
  end

  def check_doc_and_password
    user= current_user
    if !user.nil?
      if user.document.nil? or user.password.nil?
        flash[:notice] ="Debes completar el formulario."
        redirect_to user_path(user.id)+'/edit'
      end
    end
  end

  def edit
   @user = User.find params[:id]
  end

  def new
    @user = User.new
  end

  def update
    document = user_params[:document]
    if(!CiUY.validate(document))
      flash[:notice] = "Documento no verificable"
      redirect_to edit_user_path(current_user)
    else
      begin
      @user = User.find params[:id]
        if @user.update_attributes!(user_params)
          flash[:notice] = "#{@user.name} se actualizo correctamente."
          redirect_to user_path(@user)
        else
          flash[:notice] = invalid.message
          redirect_to edit_user_path(current_user)
        end
      end
    end
  end

  def show
    id = params[:id]
    @user = User.find(id)
    resolve_format @user
  end

  def create
    userFrom = params[:user][:userFrom]
    document = user_params[:document]
    image = user_params[:image]
    if(!CiUY.validate(document)or image.nil?)
      if(!CiUY.validate(document))
        flash[:notice] = "Documento no verificable"
      else
        flash[:notice] = "Falta la foto"
      end
      render '/users/new'
    else
      if(@user = User.create!(user_params))
        flash[:notice] = "#{@user.name} te registraste con exito."
        Loggermaster.Log 'info', 'Usuario '+ @user.name.to_s + ' '+ @user.surname.to_s + ' creado con éxito.'
        if(userFrom!='')
          Discount.ManageDiscount @user, userFrom
        end
        session[:user_id] = @user.id
        redirect_to shippings_path
      else
        flash[:notice] = "Informacion invalida"
        Loggermaster.Log 'error', 'No se pudo crear un usuario.'
        render '/users/new'
      end
    end
  end

=begin
  def index
    @users = User.all
    resolve_format @users
  end
=end

=begin
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "#{@user.name} borrado."
    redirect_to users_path
  end
=end

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