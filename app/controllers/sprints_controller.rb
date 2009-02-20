class SprintsController < ApplicationController
  include ProjectDependent

  # GET /project/1/sprints
  # GET /project/1/sprints.xml
  def index
    @sprints = @project.sprints.find(:all, :order => "start_date desc" )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sprints }
    end
  end

  # GET /project/1/sprints/1
  # GET /project/1/sprints/1.xml
  def show
    @sprint = @project.sprints.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sprint }
    end
  end

  # GET /project/1/sprints/new
  # GET /project/1/sprints/new.xml
  def new
    if @project.sprints.count == 0
      @sprint = Sprint.create_new(@project)
    elsif @project.sprints.last.end_date < Date.today
      @sprint = Sprint.create_next(@project.sprints.last)
    else
      flash[:notice] = "Existe ainda um sprint em andamento"
      redirect_to project_sprints_url(@project)
      return
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sprint }
    end
  end

  # GET /project/1/sprints/1/edit
  def edit
    @sprint = @project.sprints.find(params[:id])
  end

  def assign_stories
    @sprint = @project.sprints.find(params[:id], :order => "position")
    @stories = @project.stories

    respond_to do |format|
      format.html { render :action => "list_stories" }
      format.xml  { render :xml => @sprint.stories }
    end
  end

  # POST /project/1/sprints
  # POST /project/1/sprints.xml
  def create
    @sprint = @project.sprints.build(params[:sprint])

    respond_to do |format|
      if @sprint.save
        flash[:notice] = 'Sprint was successfully created.'
        format.html { redirect_to project_sprints_path(@project) }
        format.xml  { render :xml => @sprint, :status => :created, :location => @sprint }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sprint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /project/1/sprints/1
  # PUT /project/1/sprints/1.xml
  def update
    @sprint = @project.sprints.find(params[:id])

    respond_to do |format|
      if @sprint.update_attributes(params[:sprint])
        flash[:notice] = 'Sprint was successfully updated.'
        format.html { redirect_to( project_sprints_path(@project)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sprint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /project/1/sprints/1
  # DELETE /project/1/sprints/1.xml
  def destroy
    @sprint = @project.sprints.find(params[:id])
    @sprint.destroy

    respond_to do |format|
      format.html { redirect_to(project_sprints_url(@project)) }
      format.xml  { head :ok }
    end
  end

  def save_stories
    @sprint = @project.sprints.find(params[:id])
    @sprint.stories = Story.find(params[:story_ids]) if params[:story_ids]

    respond_to do |format|
      if @sprint.save
        flash[:notice] = 'Sprint was successfully created.'
        format.html {redirect_to project_sprints_path(@project) }
        format.xml  { render :xml => @sprint, :status => :created, :location => @sprint }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sprint.errors, :status => :unprocessable_entity }
      end
    end
  end

  def scrum_board
    @sprint = @project.sprints.find(params[:id])
  end

  def bourndown
     @sprint = @project.sprints.find(params[:id])
  end

  def create_bourndown
    @sprint = @project.sprints.find(params[:id])

    datas = []
    initial_date = @sprint.start_date
    while initial_date <= @sprint.end_date do
       datas << [initial_date, @sprint.total_remaining_at(initial_date)]
       initial_date += 1
    end

    #datas = [["tv",40000],["internet",10000],["magazines",50000],["other",40000]]
    bar_chart = OpenFlashChartLazy::Bar3d.new("datas")

    points_remain=OpenFlashChartLazy::Serie.new(datas,{:title=>@sprint.goal})
    bar_chart.add_serie(points_remain)


    bar_chart.bg_colour="#FFFFFF"
    bar_chart.x_axis.colour="#808080"
    bar_chart.x_axis["grid-colour"]="#A0A0A0"
    bar_chart.x_axis["3d"]=10
    bar_chart.y_axis.colour="#808080"
    bar_chart.y_axis["grid-colour"]="#A0A0A0"
    bar_chart.y_axis.min=0
    bar_chart.y_axis.max= @sprint.total_estimate + 10
    bar_chart.y_axis.steps= 5

    respond_to do |format|
      format.html { render :text => bar_chart.to_json, :layout => false }
    end
  end


end
