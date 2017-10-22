class DeliveriesController < ApplicationController

  before_action :require_login, only: [:show, :edit, :new]
  before_action :require_login or :require_login_as_admin; only[:index]
  #before_action only: [:edit] do |c| c.require_login and c.same_delivery(params[:edit]) end

  #Security methods
  def require_login
    if current_delivery.nil?
      flash[:notice] = "Tienes que estar logeado"
      redirect_to home_login_url
    end
  end

<<<<<<< HEAD
  def require_login_as_admin
    if current_admin.nil?
=======
  def same_delivery id
    if current_delivery.id != id
>>>>>>> 8278e7e09cebeb7e778c6ef4949b09a006742638
      flash[:notice] = "Tienes que estar logeado"
      redirect_to home_login_url
    end
  end

  def same_delivery id
    if current_delivery.id != id
      flash[:notice] = "Tienes que estar logeado"
      redirect_to home_login_url
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
    @delivery = Delivery.find params[:id]
    @delivery.update_attributes!(delivery_params)
    flash[:notice] = "#{@delivery.name} se actualizo correctamente."
    redirect_to delivery_path(@delivery)
  end

  def show
    id = params[:id]
    @delivery = Delivery.find(id)
    resolve_format @delivery
  end

  def create
    @delivery = Delivery.create!(delivery_params)
    flash[:notice] = "#{@delivery.name} te registraste con exito."
    session[:delivery_id] = @delivery.id
    redirect_to shippings_path
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

  def destroy
    @delivery = Delivery.find(params[:id])
    @delivery.destroy
    flash[:notice] = "#{@delivery.name} borrado."
    redirect_to deliveries_path
  end

  def active
      @delivery = Delivery.find params[:id]
      Delivery.update params[:id], active: true
      flash[:notice] = "#{@delivery.name} se activo correctamente."
      redirect_to deliveries_path
  end

end