class ShippingsController < ApplicationController

  before_action :require_login_user, only: [:new]
  before_action :require_login_delivery, only: [:edit]
  #before_action :require_login_delivery_user, only: [:show]

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

  def edit
    @shipping = Shipping.find params[:id]
  end

  def new
    @shipping = Shipping.new
    @user_cache = User.pluck(:email)
  end

  def create
    userFrom = current_user
    # envia mail al usuario si no esta registrado
    User.ExistsUserTo shipping_params[:emailTo], userFrom
    #seleciona delivery y notificacion
    delivery = Delivery.selectDelivery userFrom.name+' '+userFrom.surname, shipping_params[:addressFrom], shipping_params[:addressTo]
    shipping_params.merge(:user => userFrom, :delivery => delivery)
    @shipping = Shipping.new(shipping_params)
    @shipping.user = userFrom
    @shipping.delivery = delivery
    userFrom.applyDiscount
    if @shipping.save!
      User.SendConfirmationMail @shipping, userFrom
      flash[:notice] = "Envio creado."
      Loghelper.Log 'info', 'Envio con id '+ @shipping.id + 'fue creado con éxito.'
      redirect_to shippings_path
    else
      Loghelper.Log 'error', 'No se pudo crear envío.'
      redirect_to new_shippings_path
    end
  end

  def calculate_cost
    weight = params[:weight]
    latFrom = params[:latFrom]
    longFrom = params[:longFrom]
    latTo = params[:latTo]
    longTo = params[:longTo]
    @result = Shipping.CalculateCost longFrom, latFrom, longTo, latTo, weight, current_user.id
    render json: @result
  end

  def update
    @shipping = Shipping.find params[:id]
    @shipping.status = 1
    if @shipping.update_attributes!(shipping_params)
      User.DeliveredShipping @shipping
      flash[:notice] = "El envío fue finalizado. "
      Loghelper.Log 'info', 'Envio con id '+ @shipping.id + 'fue entregado.'
      delivery = @shipping.delivery
      delivery.latitude = @shipping.latitudeTo
      delivery.longitude = @shipping.longitudeTo
      delivery.save!
      redirect_to shippings_path
    else
      flash[:notice] = "No se pudo realizar el envío, algun parámetro inválido."
      Loghelper.Log 'error', 'No se pudo entregar el envío con id '+ @shipping.id + '.'
      redirect_to edit_delivery_path(current_delivery)
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