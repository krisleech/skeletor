# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_skeletor_session',
  :secret      => '62beeb3ccf5cfa9d0b8e01c190fb79732013d9f1384ea9e92cc4c3ce5383cbf92e5040934000bb48122279dbaf3c90a77fd59e4d87a34e1cac1f6c63eac6ff9e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
