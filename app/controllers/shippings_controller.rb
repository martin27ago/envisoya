class ShippingsController < ApplicationController

  def new
    @shipping = Shipping.new
    @user_cache = User.pluck(:email)
    #parte de descuento
  end

  def create
    @userFrom = current_user
    User.ExistUserReceiver shipping_params[:emailTo], @userFrom.name+' '+@userFrom.surname
    @delivery = Delivery.selectDelivery @userFrom.name+' '+@userFrom.surname, shipping_params[:addressFrom], shipping_params[:addressTo]
    shipping_params.merge(:user => @userFrom, :delivery => @delivery)
    @shipping = Shipping.new(shipping_params)
    @shipping.user = @userFrom
    @shipping.delivery = @delivery
    @shipping.save!
    flash[:notice] = "Envio creado."
  end

  def shipping_params
    params.require(:shipping).permit(:emailTo, :latitudeFrom, :latitudeTo, :longitudeFrom, :longitudeTo, :addressFrom, :addressTo, :price, :postalCodeFrom, :postalCodeTo)
  end
end