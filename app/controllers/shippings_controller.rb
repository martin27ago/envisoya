class ShippingsController < ApplicationController

  before_action :require_login_user, only: [:new]
  before_action :require_login_delivery, only: [:edit]
  before_action :require_login_delivery_user, only: [:show]

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
    #parte de descuento
  end

  def create
    userFrom = current_user
    User.ExistUserReceiver shipping_params[:emailTo], userFrom
    delivery = Delivery.selectDelivery userFrom.name+' '+userFrom.surname, shipping_params[:addressFrom], shipping_params[:addressTo]
    shipping_params.merge(:user => userFrom, :delivery => delivery)
    @shipping = Shipping.new(shipping_params)
    @shipping.user = userFrom
    @shipping.delivery = delivery
    @shipping.save!
    userFrom.applyDiscount
    flash[:notice] = "Envio creado."
    redirect_to shippings_path
  end

  def shipping_params
    params.require(:shipping).permit(:emailTo, :latitudeFrom, :latitudeTo, :longitudeFrom, :longitudeTo, :addressFrom, :addressTo, :price, :postalCodeFrom, :postalCodeTo)
  end

  def resolve_format(obj)
    respond_to do |format|
      format.html
      format.xml { render :xml => obj }
      format.json { render :json => obj }
    end
  end
end