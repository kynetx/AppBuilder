class ManageController < ApplicationController
  before_filter :logged_in
  
  def index  
    
  end
  
  def change_owner
    
  end
  
  def remove_user
    current_application.remove_user(params[:userid])
    redirect_to :action => "index", :id => current_application.application_id
  end
  
  def share
    if ! params[:email].blank? && ! params[:message].blank?
      current_application.share(params[:email], params[:message])
      flash[:notice] = "Invitation Sent"
    else
      flash[:error] = "Please provide both an email address and a message."
    end
    redirect_to :action => "index", :id => current_application.application_id
  end
  
  def cancel_invite
    current_application.cancel_invite(params[:invite_id])
    redirect_to :action => "index", :id => current_application.application_id
  end
  
  def transfer_owner
    current_application.transfer_owner(params[:userid], params[:message])
    redirect_to :action => "index", :id => current_application.application_id
  end
  
  def cancel_transfer
    current_application.cancel_transfer(params[:transferrequestid])
    redirect_to :action => "index", :id => current_application.application_id    
  end
  
  def add_image   
    
    
    #puts "IMAGE_DATA: #{params[:image].original_filename}, #{params[:image].content_type}, #{params[:image].read}"
    
    current_application.set_image(params[:image].original_filename, params[:image].content_type, params[:image].read)
    redirect_to :action => "index", :id => current_application.application_id    
  end
  
end
