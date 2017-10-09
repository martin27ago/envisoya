class UsersController < ApplicationController

  def edit
   @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    @user.update_attributes!(user_params)
    flash[:notice] = "#{@user.name} was successfully updated."
    redirect_to user_path(@user)
  end

  def user_params
    params.require(:user).permit(:name, :surname, :mail, :document)
  end

  def resolve_format(obj)
    respond_to do |format|
      format.html
      format.xml { render :xml => obj }
      format.json { render :json => obj }
    end
  end

  def show
    id = params[:id]
    @user = User.find(id)
    resolve_format @user
  end
end