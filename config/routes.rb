ActionController::Routing::Routes.draw do |map|
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.oauth_connect "oauth_connect", :controller => "applist", :action => "oauth_connect"
  map.authorize "authorize", :controller => "applist", :action => "authorize"
  map.duplicate "duplicate/:application_id", :controller => "users", :action => "duplicate_application"

  map.resources :applications, :member => { :show_deploy => :get, :deploy => :get, :update => :put }

  # High level mapping
  map.manage "manage/:id", :controller => "manage", :action => "index"
  map.test "test/:id", :controller => "test_app", :action => "index"
  map.deploy "deploy/:id", :controller => "deploy_app", :action => "index"  
  map.distribute "distribute/:id", :controller => "distribute_app", :action => "index" 
  
  # Second level mapping. Use for accessing actions other than index
  map.manage_app "manage_app/:action", :controller => "manage"
  map.test_app "test_app/:action", :controller => "test_app"
  map.deploy_app "deploy_app/:action", :controller => "deploy_app"
  map.distribute_app "distribute_app/:action/:id", :controller => "distribute_app"
  
  
  # Don't allow any routes to :users
  #map.resources :users
 # map.connect "apps", :controller => "applist", :action => "index"
  # map.connect "manage/:action/:id", :controller => "manage"
  # map.connect "test/:action/:id", :controller => "test_app"
  # map.connect "deploy/:action/:id", :controller => "deploy_app"
  # map.connect "distribute/:action/:id", :controller => "distribute_app"  
  # map.connect "edit/:action/:id", :controller => "edit_app"
  # map.connect "save/:id", :controller => "edit_app", :action => "save"
  #map.connect "/:action/:id", :controller => "applist"
  
  # map.edit "edit/:id", :controller => "edit_app", :action => "index"
  # map.manage "manage/:id", :controller => "manage", :action => "index"
  # map.test "test/:id", :controller => "test_app", :action => "index"
  # map.distribute "distribute/:id", :controller => "distribute_app", :action => "index"
  # map.deploy "deploy/:id", :controller => "deploy_app", :action => "index"
  

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action



  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "applist"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
