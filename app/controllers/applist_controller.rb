require "kynetx_am_api"

class ApplistController < ApplicationController
  
  before_filter :logged_in, :except => [:oauth_connect, :index, :authorize]
  
  def index
    # If they are logged in the root is their application list.
    redirect_to applications_path() if is_authorized
  end

  def oauth_connect
    new_page = root_url
    begin
      api = KynetxAmApi::DirectApi.new
      new_page = api.get_authorize_url
      request_token = api.get_request_token
      session[:request_token] = {:request_token => request_token.token,
                                 :request_secret => request_token.secret}
    rescue Exception => e
      puts e.message
      puts e.backtrace().join("\n")
      flash[:error] = "There was a problem logging you in."
    end
    
    redirect_to new_page
  end
  
  def authorize
    new_page = applications_path();
    
    begin
      raise "Unknown Oauth Request Token" unless session[:request_token]
      
      rt = session[:request_token]

      api = KynetxAmApi::DirectApi.new(rt.merge({:oauth_verifier => params[:oauth_verifier]}))
      oauth_user = api.get_user_info
      
      # Remove any expired users
      User.delete_all ["userid = ? AND expires < ?", oauth_user.userid, Time.now.to_i ] 
      
      Rails.logger.debug { "Cookie: #{cookies[:user_credentials]}" } 
      
      existing_user = User.find :first, :conditions => ["userid = ? AND persistence_token = ?", oauth_user.userid, cookies[:user_credentials]]
      
      Rails.logger.debug { "FOUND USER: #{existing_user.name}\n#{existing_user.persistence_token}" } if existing_user
      
      
      @user = existing_user ||
        User.create({:password => 'KYNETX ROCKS!',
                     :password_confirmation => "KYNETX ROCKS!",
                     :request_token => oauth_user.request_token,
                     :request_secret => oauth_user.request_secret,
                     :access_token => oauth_user.access_token,
                     :access_secret => oauth_user.access_secret,
                     :username => oauth_user.username,
                     :userid => oauth_user.userid,
                     :name => oauth_user.name,
                     :expires => (Time.now + 2.weeks).to_i})
      
      @user_session = UserSession.create(@user, true)

    rescue Exception => e
      Rails.logger.debug e.message
      Rails.logger.debug e.backtrace.join("\n")

      Rails.logger.debug { "Unable to authorize: #{$!}" }
      flash[:error] = "Not Authorized. Our bad."
      new_page = root_url
    end
    
    redirect_to new_page
  end
  
  def ping
    @response = @apps = current_user.api.ping
  end
  
  
  
end
