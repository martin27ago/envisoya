class DeliveriesController < ApplicationController

  before_action :require_login, only: [:show, :edit]
  before_action :admin_login, only: [:index, :destroy, :active]
  before_action :is_log, only: [:new]
  before_action :check_doc_and_password, only: [:show]
  #Security methods
  def require_login
    if current_delivery.nil?
      flash[:notice] = "Tienes que estar logeado"
      redirect_to home_login_url
    end
  end

  def admin_login
    if !current_user.nil? and !current_user.admin
      flash[:notice] = "Solo puede ingresar el admin"
      redirect_to home_login_url
    end
  end

  def is_log
    if !current_user.nil? or !current_delivery.nil?
      flash[:notice] = "No puedes registrarte como cadete si estas logeado"
      redirect_to home_login_url
    end
  end

  def same_delivery id
    if current_delivery.id != id
      flash[:notice] = "Tienes que estar logeado"
      redirect_to home_login_url
    end
  end

  def check_doc_and_password
    delivery= current_delivery
    if !delivery.nil?
      if delivery.document.nil? or delivery.password.nil?
        flash[:notice] ="Debes completar el formulario."
        redirect_to delivery_path(delivery.id)+'/edit'

      end
    end
  end

#Actions
  def new
    @delivery = Delivery.new
  end

  def edit
    @delivery = Delivery.find params[:id]
  end

  def update
    document = delivery_params[:document]
    if(!CiUY.validate(document))
      flash[:notice] = "Documento no verificable"
      redirect_to edit_delivery_path(current_delivery)
    else
      begin
      @delivery = Delivery.find params[:id]
      if @delivery.update_attributes!(delivery_params)
        flash[:notice] = "#{@delivery.name} se actualizo correctamente."
        Loggermaster.Log 'info', 'Cadete '+ @delivery.name + ' '+ @delivery.surname + ' actualizado con éxito.'
        redirect_to delivery_path(@delivery)
      else
        flash[:notice] = "Informacion inválida"
        Loggermaster.Log 'error', 'Error al intentar editar cadete, parametros no válidos'
        redirect_to edit_delivery_path(current_delivery)
      end
      end
    end
  end

  def show
    id = params[:id]
    @delivery = Delivery.find(id)
    resolve_format @delivery
  end

  def create
    document = delivery_params[:document]
    image = delivery_params[:image]
    if(!CiUY.validate(document) or image.nil?)
      if(!CiUY.validate(document))
        flash[:notice] = "Documento no verificable"
      else
        flash[:notice] = "Falta la foto"
      end
      render '/deliveries/new'
    else
      if(@delivery = Delivery.create!(delivery_params))
        flash[:notice] = "#{@delivery.name} te registraste con exito."
        session[:delivery_id] = @delivery.id
        Loggermaster.Log 'info', 'Cadete '+ @delivery.name + ' '+ @delivery.surname + ' creado con éxito.'

        redirect_to shippings_path
      else
        flash[:notice] = "Informacion invalida"
        Loggermaster.Log 'error', 'No se pudo crear Cadete, error en los para.'
        render '/deliveries/new'
      end
    end
  end

  def index
    @deliveries = Delivery.all
    resolve_format @deliveries
  end

  def delivery_params
    params.require(:delivery).permit(:name, :surname, :email, :document, :password, :image, :license, :papers)
  end

  def resolve_format(obj)
    respond_to do |format|
      format.html
      format.xml { render :xml => obj }
      format.json { render :json => obj }
    end
  end

=begin
  def destroy
    @delivery = Delivery.find(params[:id])
    @delivery.destroy
    flash[:notice] = "#{@delivery.name} borrado."
    redirect_to deliveries_path
  end
=end

  def active
      @delivery = Delivery.find params[:id]
      Delivery.update params[:id], active: true
      flash[:notice] = "#{@delivery.name} se activo correctamente."
      redirect_to deliveries_path
  end

end