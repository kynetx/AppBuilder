# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_appbuilder_session',
  :secret      => '90c9c85cf525bce38de548d64d48d7f19d99fb6680054ca3ac7fccc7097e39ca7362eb8d297dd00b801556b4265105f6c9b8e7a3bee66d5a18afe4726d11b400'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
