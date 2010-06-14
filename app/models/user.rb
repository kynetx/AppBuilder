class User < ActiveRecord::Base
  require 'pp'
  # attr_accessor :api
  acts_as_authentic

  def api(force=false)
    if force
      @kapi = kynetx_user.api
    else
      @kapi ||= kynetx_user.api
    end
    return @kapi
  end

  def kynetx_user
    @kuser ||= KynetxAmApi::User.new(self)
    return @kuser
  end

end
