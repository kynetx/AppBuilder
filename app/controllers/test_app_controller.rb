class TestAppController < ApplicationController
  before_filter :logged_in
  def index
    @bookmarklet = current_application.bookmarklet("dev", "init.kobj.net/js/shared/kobj-static.js")
  end

end
