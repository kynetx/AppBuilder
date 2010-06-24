class TestAppController < ApplicationController
  before_filter :logged_in
  def index
    bm = current_application.endpoint("bookmarklet", :env => 'dev')
    if bm["errors"].empty?
      @bookmarklet = bm["data"]
    else 
      @bookmarklet = ""
      flash[:error] = "There was an error generating your bookmarklet. #{bm["errors"].join(" ")}"
    end
  end

end
