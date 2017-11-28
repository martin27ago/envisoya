class ShippingsController < ApplicationController

  before_action :require_login_user, only: [:new]
  before_action :require_login_delivery, only: [:edit]
  # before_action :require_login_delivery_user, only: [:show]
  before_action :check_doc_and_password, only: [:new, :index]

  # Validation methods
  def require_login_user
    if current_user.nil?
      flash[:notice] = "Tienes que estar logeado"
      redirect_to home_login_url
    end
  end

  def require_login_delivery
    if current_delivery.nil?
      flash[:notice] = "Tienes que estar logeado"
      redirect_to home_login_url
    end
  end

  def require_login_delivery_user
    if current_user.nil? and @current_delivery.nil?
      flash[:notice] = "Tienes que estar logeado"
      redirect_to home_login_url
    end
  end

  def check_doc_and_password
    user = current_user
    delivery = current_delivery
    if user.nil?
      if delivery.document.nil? or delivery.password.nil?
        flash[:notice] ="Debes completar el formulario."
        redirect_to delivery_path(delivery.id)+'/edit'

      end
    else
        if user.document.nil? or user.password.nil?
          flash[:notice] ="Debes completar el formulario."
          redirect_to user_path(user.id)+'/edit'
        end
    end
  end

  # Actions
  def show
    id = params[:id]
    @shipping = Shipping.find(id)
    resolve_format @shipping
  end

  def index
    if(current_user.nil?)
      @shippings = Shipping.where("delivery_id = ?", current_delivery.id)
    else
      @shippings = Shipping.where("user_id = ?", current_user.id)
    end
  end

  def new
    if(!CostsService.health_check_costs())
      flash[:notice] = "En este momento no se pueden realizar envios."
      redirect_to home_login_url
    end
    @shipping = Shipping.new
    @user_cache = User.pluck(:email)
  end

  def edit
    @shipping = Shipping.find params[:id]
  end
  
  def create
    userFrom = current_user
    # envia mail al usuario si no esta registrado
    User.exists_user_to shipping_params[:emailTo], userFrom
    # selecciona delivery y notificacion
    delivery = Delivery.select_delivery userFrom.name+' '+userFrom.surname, shipping_params[:addressFrom], shipping_params[:addressTo]
    shipping_params.merge(:user => userFrom, :delivery => delivery)
    @shipping = Shipping.new(shipping_params)
    @shipping.user = userFrom
    @shipping.delivery = delivery
    userFrom.apply_discount
    if @shipping.save!
      User.send_confirmation_mail @shipping, userFrom
      flash[:notice] = "Envio creado."
      LoggerHelper.Log 'info', 'Envio con id '+ @shipping.id.to_s + ' fue creado con éxito.'
      redirect_to shippings_path
    else
      LoggerHelper.Log 'error', 'No se pudo crear envío.'
      redirect_to new_shippings_path
    end
  end

  def calculate_cost
    weight = params[:weight]
    lat_from = params[:latFrom]
    long_from = params[:longFrom]
    lat_to = params[:latTo]
    long_to = params[:longTo]
    @result = Shipping.calculate_cost long_from, lat_from, long_to, lat_to, weight, current_user.id
    render json: @result
  end

  def update
    begin
      @shipping = Shipping.find params[:id]
      @shipping.status = 1
      if @shipping.update_attributes!(shipping_params)
        User.delivered_shipping @shipping
        flash[:notice] = "El envío fue finalizado. "
        LoggerHelper.Log 'info', 'Envio con id ' + @shipping.id.to_s + ' fue entregado.'
        delivery = @shipping.delivery
        delivery.latitude = @shipping.latitudeTo
        delivery.longitude = @shipping.longitudeTo
        delivery.save!
        redirect_to shippings_path
      else
        flash[:notice] = "No se pudo realizar el envío, algun parámetro inválido."
        LoggerHelper.Log 'error', 'No se pudo entregar el envío con id '+ @shipping.id + '.'
        redirect_to edit_shipping_path(@shipping)
      end
    rescue
      flash[:notice] = "No se pudo realizar el envío, algun parámetro inválido."
      LoggerHelper.Log 'error', 'No se pudo entregar el envío con id '+ @shipping.id + '.'
      redirect_to edit_shipping_path(@shipping)
    end
  end

  def shipping_params
    params.require(:shipping).permit(:emailTo, :latitudeFrom, :latitudeTo, :longitudeFrom, :longitudeTo, :addressFrom, :addressTo, :price, :postalCodeFrom, :postalCodeTo, :weight, :estimatedPrice, :discount)
  end

  def resolve_format(obj)
    respond_to do |format|
      format.html
      format.xml { render :xml => obj }
      format.json { render :json => obj }
    end
  end
end