config.cache_classes = false

config.whiny_nils = true

config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

config.action_mailer.raise_delivery_errors = true

config.gem 'rack-bug', :lib => 'rack/bug'

config.middleware.use "Rack::Bug",
  :secret_key => "epT5uCIchlsHCeR9dloOeAPG66PtHd9K8l0q9avitiaA/KUrY7DE52hD4yWY+8z1",
  :password   => Settings.debug.rack_bug_password,
  :ip_masks => nil