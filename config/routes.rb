ActionController::Routing::Routes.draw do |map|
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.register "register", :controller => "users", :action => "new"
  map.resource :user_session
  map.resources :password_resets
  map.resources :users, :controller => 'users'

  map.root  :controller => 'documents', :action => 'show', :path => 'home'

  map.sendmail '/sendmail', :controller => 'sendmail', :action => 'deliver'

  map.admin_backup_database '/admin/backup/database', :controller => 'admin/backups', :action => 'database'
  map.admin_backup_files '/admin/backup/files', :controller => 'admin/backups', :action => 'files'
  map.admin_backup '/admin/backup', :controller => 'admin/backups'

  # Admin Routes
  map.admin_dashboard 'admin', :controller => 'admin/admin', :action => 'dashboard'
  map.admin_system 'admin/system', :controller => 'admin/admin', :action => 'system'
  map.namespace(:admin) do |admin|
    admin.resources :users
    admin.resources :documents, :member => { :generate_template => :post, :preview => :get, :up => :get, :down => :get }
    admin.resources :meta_definitions
  end

  # System Routes
  map.system_dashboard 'system', :controller => 'system/system', :action => 'dashboard'
  map.system_system 'admin/system', :controller => 'system/system', :action => 'system'
  map.namespace(:system) do |system|
    system.resources :meta_definitions, :member => { :up => :get, :down => :get }
  end

  map.document_search_all  '/search', :controller => 'documents', :action => 'search_all'
  map.add_document '/:id/add/:label', :controller => 'documents', :action => 'create'  
  map.document_archive  '/*path/archive/:month/:year', :controller => 'documents', :action => 'archive'
  map.document_search  '/*path/search', :controller => 'documents', :action => 'search'

  # catch-all
  map.document '*path', :controller => 'documents', :action => 'show'
end
