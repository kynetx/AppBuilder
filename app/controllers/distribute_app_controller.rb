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
    
    opts = {}
    opts[:extname] = params[:name] unless params[:name].blank?
    opts[:extauthor] = params[:author] unless params[:author].blank?
    opts[:extdesc] = params[:description] unless params[:description].blank?
    opts[:force_build] = 'Y' if params[:force]
    opts[:format] = 'url'


    ext = current_application.endpoint(extension_type, opts)
    
    if ext["errors"].empty?
      redirect_to ext["data"]
    else
      flash[:error] = "Unable to generate your extension. Error: #{ext["errors"].join(" ")}"
      redirect_to :action => "extension"
    end
    
  end
  
  def infocard

  end
  
  def gen_infocard
    next_page = "" 
    puts "PARAMS: #{params.inspect}"
    opts = {}
    opts[:extname] = params[:name] unless params[:name].blank?
    opts[:datasets] = params[:datasets] unless params[:datasets].blank?
    opts[:env] = params[:env] unless params[:env].blank?
    opts[:force_build] = 'Y' if params[:force]
    opts[:format] = 'url'

    card = current_application.endpoint("info_card", opts)

    if card["errors"].empty?
      redirect_to card["data"]
    else
      flash[:error] = "Unable to generate your InfoCard. Error: #{ext["errors"].join(" ")}"
      redirect_to :action => "infocard"
    end
    
  end
  
  
  def tags
    
  end
  
  def bookmarklet
    bm = current_application.endpoint("bookmarklet")
    if bm["errors"].empty?
      @bookmarklet = bm["data"]
    else
      @bookmarklet = ""
      flash[:error] = "There was an error generating your bookmarklet. #{bm["errors"].join(" ")}"
    end
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
