class TasksController < ApplicationController
  include ProjectDependent
  before_filter :require_authentication
  before_filter :load_data, :except => [:update_task_status]
  protect_from_forgery :except => [:update_task_status]

  # GET /tasks
  # GET /tasks.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    @task = @story.tasks.build
    @users = User.find(:all)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
    @users = User.find(:all)
  end

  # POST /tasks
  # POST /tasks.xml
  def create
    @task = @story.tasks.build(params[:task])
    @task.status = "TODO"
    respond_to do |format|
      if @task.save
        flash[:notice] = 'Task was successfully created.'
        format.html { redirect_to project_story_tasks_path(@project, @story) }
        format.xml  { render :xml => @task, :status => :created, :location => @task }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        flash[:notice] = 'Task was successfully updated.'
        format.html { redirect_to project_story_tasks_path(@project, @story) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to project_story_tasks_url(@project, @story) }
      format.xml  { head :ok }
    end
  end

  def update_task_status
     if !params[:data].blank? && !params[:status].blank?
       status = "TODO"
       if params[:status].include? "WORKING"
         status = "WORKING"
       end
       if params[:status].include? "DONE"
         status = "DONE"
       end

       if params[:data].include? ","
         @ids = params[:data].split(",")
         for id in @ids
            @task = Task.find(id)
            if !@task.nil?
              @task.status = status
              @task.save
            end
         end
       else
         @task = Task.find(params[:data])
         if !@task.nil?
           @task.status = status
           @task.save
         end
       end
     end

     respond_to do |format|
        format.js { render :text => "ok" }
     end
  end

  private

  def load_data
    @story = Story.find(params[:story_id])
    @tasks = @story.tasks
  end
end
