# See how all your routes lay out with "rake routes"
ActionController::Routing::Routes.draw do |map|

  map.resources :projects do |projects|
    projects.resources :stories, :member => { :estimate => :post }, :collection => { :current_sprint => :get, :sort => :post } do |story|
      story.resources :tasks
    end

    projects.resources :wikis
    projects.resources :project_users, :collection => { :editing => :get }
  	projects.resources :sprints, :member => { :save_stories => :post, :assign_stories => :get , :scrum_board => :get, :burndown => :get, :create_burndown => :get }
  end

  map.update_task_status '/projects/:project_id/updatets', :controller => 'tasks', :action => 'update_task_status', :requirements => { :method => :put }

  # RESTful rewrites
  map.signup   '/signup',   :controller => 'users',    :action => 'new'
  map.register '/register', :controller => 'users',    :action => 'create'
  map.activate '/activate/:activation_code', :controller => 'users',    :action => 'activate'
  map.login    '/login',    :controller => 'sessions', :action => 'new'
  map.logout   '/logout',   :controller => 'sessions', :action => 'destroy', :conditions => {:method => :delete}

  map.user_troubleshooting '/users/troubleshooting', :controller => 'users', :action => 'troubleshooting'
  map.user_forgot_password '/users/forgot_password', :controller => 'users', :action => 'forgot_password'
  map.user_reset_password  '/users/reset_password/:password_reset_code', :controller => 'users', :action => 'reset_password'
  map.user_forgot_login    '/users/forgot_login',    :controller => 'users', :action => 'forgot_login'
  map.user_clueless        '/users/clueless',        :controller => 'users', :action => 'clueless'

  map.open_id_complete '/opensession', :controller => "sessions", :action => "create", :requirements => { :method => :get }
  map.open_id_create '/opencreate', :controller => "users", :action => "create", :requirements => { :method => :get }

  map.resources :users, :member => { :edit_password => :get,
                                     :update_password => :put,
                                     :edit_email => :get,
                                     :update_email => :put,
                                     :edit_avatar => :get,
                                     :update_avatar => :put }

  map.resource :session

  # Profiles
  map.resources :profiles

  # Administration
  map.namespace(:admin) do |admin|
    admin.root :controller => 'dashboard', :action => 'index'
    admin.resources :settings
    admin.resources :users, :member => { :suspend   => :put,
                                         :unsuspend => :put,
                                         :activate  => :put,
                                         :purge     => :delete,
                                         :reset_password => :put },
                            :collection => { :pending   => :get,
                                             :active    => :get,
                                             :suspended => :get,
                                             :deleted   => :get }
  end

  # Dashboard as the default location
  map.root :controller => 'dashboard', :action => 'index'

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
