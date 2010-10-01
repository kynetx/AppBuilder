class ApplicationsController < ApplicationController
  before_filter :logged_in

  def index
    @applications = current_user.applications
  end

  def edit
    begin
      @application = current_application
    rescue
      render :status => 500,  :text => "We are sorry, there appears to be a problem accessing the Kynetx API. Please try again later."
    end
  end

  def update
    begin
      if params[:krl]
        response = (current_application.krl = params[:krl])
        render :text => response
      end
    rescue KRLParseError => e
      Rails.logger.error "APP UPDATE ERROR:\n #{e.message}\n#{e.backtrace}"
      render :status => 400, :text => e.parse_errors.join("<br/>")
    end
  end

  def create
    
    if params[:name]
      @application = current_user.create_application(params[:name], params[:description])
    end
    
    next_page = root_url
    if @application
          
      next_page = {:action => "edit", :id => @application.application_id}
      
    else
      flash[:error] = "Couldn't create your application. #{$!}"
    end
    
    redirect_to next_page
  end

  def new
    # TODO: create a new application
  end

  def destroy
    current_application.delete
    redirect_to :action => "index"
  end

  def lame
    begin
      @application = current_application
    rescue
      render :status => 500,  :text => "We are sorry, there appears to be a problem accessing the Kynetx API. Please try again later."
    end
  end

end
