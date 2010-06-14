# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  helper_method :current_user_session, :current_user, :logged_in, :is_authorized, :current_application

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user.kynetx_user
  end
  
  def current_application
    @current_user_api ||= current_user.find_application(:application_id => params[:id], :version => "development")
  end
  
  def logged_in
    unless (current_user)
      redirect_to root_url
    end
  end
  
  def is_authorized
    return current_user && (!current_user.access_token.blank?)
  end
end
