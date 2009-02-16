class StoriesController < ApplicationController

  before_filter :load_project


  #alterei...

  # GET /projects/1/stories
  # GET /projects/1/stories.xml
  def index
    @stories = @project.current_sprint_stories

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stories }
    end
  end

  # GET /projects/1/stories/1
  # GET /projects/1/stories/1.xml
  def show
    @story = @project.stories.find(params[:story_id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @story }
    end
  end

  # GET /projects/1/stories/new
  # GET /projects/1/stories/new.xml
  def new
    @story = @project.stories.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @story }
    end
  end

  # GET /projects/1/stories/1/edit
  def edit
    @story = @project.stories.find(params[:story_id])
  end

  # POST /projects/1/stories
  # POST /projects/1/stories.xml
  def create
    @story = @project.stories.build(params[:story])

    respond_to do |format|
      if @story.save
        flash[:notice] = 'Story was successfully created.'
        format.html { redirect_to(@story) }
        format.xml  { render :xml => @story, :status => :created, :location => @story }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1/stories/1
  # PUT /projects/1/stories/1.xml
  def update
    @story = @project.stories.find(params[:story_id])

    respond_to do |format|
      if @story.update_attributes(params[:story])
        flash[:notice] = 'Story was successfully updated.'
        format.html { redirect_to(@story) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1/stories/1
  # DELETE /projects/1/stories/1.xml
  def destroy
    @story = @project.stories.find(params[:story_id])
    @story.destroy

    respond_to do |format|
      format.html { redirect_to(stories_url) }
      format.xml  { head :ok }
    end
  end
end
