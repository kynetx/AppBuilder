require "base64"
class DistributeAppController < ApplicationController
  before_filter :logged_in
  
  def index
  end
  
  def extension
    
  end
  
  def gen_extension
    ext = ""   
    extension_type = ""    
    if params[:ff]
      extension_type = "firefox"      
    elsif params[:cr]
      extension_type = "chrome"
    elsif params[:ie]
      extension_type = "ie"
    end
    
    ext = current_application.extension(extension_type, params[:name].to_s, params[:author].to_s, params[:description].to_s)
    
    if ext["errors"].empty?
      return send_data Base64.decode64(ext["data"]), :filename => ext["file_name"], :type => ext["content_type"]
    end
    
    render :text => ext
  end
  
  def infocard

  end
  
  def gen_infocard
    next_page = "" 
    
    if params[:name].blank?
      flash[:error] = "Please provide a name for your card."      
    else
      env = params[:env] ? params[:env] : "prod"
      card = current_application.infocard(params[:name], params[:datasets], env)
      puts card.inspect
      return send_data  Base64.decode64(card["data"]), :filename => card["file_name"], :type => card["content_type"]
    end
    redirect_to :action => "infocard"
  end
  
  
  def tags
    
  end
  
  def bookmarklet
    @bookmarklet = current_application.bookmarklet
  end
  
  def marketplace
    @listing = HTTParty.get(MARKETPLACE_URL + "/api/0.1/listingDetail", :query => {:ruleset_id => current_application.application_id})
    @found = @listing["found"]
    @price = @listing["price"] if @found
    @mp_user = HTTParty.get(MARKETPLACE_URL + "/api/0.1/userDetail", :query => {:kynetxuserid => current_user.userid})
    @mp_user_found = @mp_user["found"]
  end
  
  def list_app
    
    query = {
      :ruleset_id => current_application.application_id, 
      :name => current_application.name,
      :kynetxuserid => current_user.userid}
    query[:image] = current_application.image_url(:normal) unless current_application.image_url.include?("missing")
    
    
    response = HTTParty.get(MARKETPLACE_URL + "/api/0.1/listApp", 
      :query => query)
    next_page = {:action => "marketplace", :id => current_application.application_id}
    if response["success"]
      next_page = response["callback_url"]
    else 
      flash[:error] = response["error"] || "Unable to create the Marketplace listing."
    end
    redirect_to next_page
  end


end
