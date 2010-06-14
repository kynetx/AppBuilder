class UserSessionsController < ApplicationController
  def new
    redirect_to :controller => "applist", :action => "oauth_connect"
  end
  
  def destroy
    if current_user_session
      current_user_session.user.destroy
      current_user_session.destroy         
    end
    flash[:notice] = "You have been logged out."
    redirect_to root_url
  end
  

end
