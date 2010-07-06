class DeployAppController < ApplicationController
  before_filter :logged_in
  
  def index
    # tmp_app_info = {"production"=>{"format"=>"json", "KynetxUserID"=>8, "version"=>4, "note"=>nil, "created"=>"2009-12-09 22:56:15 UTC"}, "valid"=>true, "versions"=>[{"format"=>"json", "KynetxUserID"=>18, "version"=>0, "note"=>nil, "created"=>"2009-11-20 23:12:07 UTC"}, {"format"=>"json", "KynetxUserID"=>18, "version"=>1, "note"=>nil, "created"=>"2009-11-20 23:20:43 UTC"}, {"format"=>"json", "KynetxUserID"=>18, "version"=>2, "note"=>nil, "created"=>"2009-11-20 23:39:14 UTC"}, {"format"=>"json", "KynetxUserID"=>18, "version"=>3, "note"=>nil, "created"=>"2009-11-20 23:41:24 UTC"}, {"format"=>"json", "KynetxUserID"=>8, "version"=>4, "note"=>nil, "created"=>"2009-12-09 22:56:15 UTC"}], "development"=>{"format"=>"json", "KynetxUserID"=>8, "version"=>4, "note"=>nil, "created"=>"2009-12-09 22:56:15 UTC"}, "appid"=>"a18x8"}
    #     
    #     @prod_version = tmp_app_info["production"]["version"]
    #     @versions = tmp_app_info["versions"]
    
    @ruleset_id = params[:id]
    @app = current_application
    @versions = @app.versions.reverse
    @prod_version = @app.production_version
  end
  
  def version_note
    current_application.set_version_note(params[:version], params[:note])
    redirect_to :action => "index", :id => params[:id]
  end
  
  def deploy_version
    @ruleset_id = params[:id]
    current_application.production_version = params[:version]
    redirect_to :action => "index", :id => @ruleset_id    
  end
  
  def version_source
    @ruleset_id = params[:id]
    @version = params[:version]
    begin
      @source = current_application.krl(@version)
    rescue
      render :status => 500
    end
    render :layout => false
  end


end
