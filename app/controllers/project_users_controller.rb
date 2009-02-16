class ProjectUsersController < ApplicationController

  # GET /project_users
  # GET /project_users.xml
  def index
    project_id = params[:pid]
    @project = Project.find_by_id(project_id)
    @project_users = ProjectUser.find(:all, :conditions => ["project_id = ?", project_id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @project_users }
    end
  end


  # GET /project_users/new
  # GET /project_users/new.xml
  def edit
    @project = Project.find_by_id(params[:id])
    @users = User.find(:all)
    @project_users = ProjectUser.find(:all, :conditions => ["project_id = ?", @project.id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @project_users }
    end
  end


  # POST /project_users
  # POST /project_users.xml
  def create
  	@project = Project.find_by_id(params[:pid])
    @users = User.find(:all)
    @project_users = ProjectUser.find(:all, :conditions => ["project_id = ?", @project.id])

		for user in @users
			is_checked = params["user_id#{user.id}"]
			if is_checked
				if !exist_in_list(@project_users, user)
					project_user = ProjectUser.new
					project_user.project_id = @project.id
					project_user.user_id = user.id
					project_user.user_type = params["user_type#{user.id}"]
					@project.project_users << project_user
				end
			else
				project_user = ProjectUser.find(user.id)
				if !project_user.nil?
			    project_user.destroy
					@project.project_users.delete(project_user)
				end
			end
		end

    respond_to do |format|
			flash[:notice] = 'ProjectUsers was successfully created.'
      format.html { redirect_to :controller => "projects", :id => @project.id }
    end
  end


  # DELETE /project_users/1
  # DELETE /project_users/1.xml
  def destroy
    @project_user = ProjectUser.find(params[:id])
    @project_user.destroy

    respond_to do |format|
      format.html { redirect_to :action => "index", :pid => @project_user.project_id }
      format.xml  { head :ok }
    end
  end


	def exist_in_list(project_users, user)
		for u in project_users
			return true if (u.user_id == user.id)
		end
		return false
	end

	def get_project_user_by_user(project_users, user)
		for u in project_users
			if user.id == u.user_id
				return u
			end
		end
		return nil
	end
end
