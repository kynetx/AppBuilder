class UsersController < ApplicationController
  def new
    redirect_to ACCOUNTS_URL + "/signup/developer"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Successfully created user."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated user."
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end
  
  def duplicate_application
    raise "Unkown app" unless params[:application_id]
    new_app = current_user.duplicate_application(params[:application_id])
    redirect_to root_url
  end
  
end
