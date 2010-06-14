# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

config.log_level = :debug

# $DEBUG = true

require 'yaml'
appbuilder_config = YAML.load_file(File.join(RAILS_ROOT,'config','appbuilder.yml'))

KynetxAmApi::Oauth.consumer_key    = appbuilder_config[:development][:oauth][:consumer_key]
KynetxAmApi::Oauth.consumer_secret = appbuilder_config[:development][:oauth][:consumer_secret]

KynetxAmApi::Oauth.api_server_url = "http://amapi.kynetx.com"
KynetxAmApi::Oauth.accounts_server_url = "https://accounts.kynetx.com"
MARKETPLACE_URL = "http://marketplace-staging.kynetx.com"
