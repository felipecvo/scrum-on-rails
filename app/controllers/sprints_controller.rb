class SprintsController < ApplicationController
  # GET /sprints
  # GET /sprints.xml
  def index
    @sprints = Sprint.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sprints }
    end
  end

  # GET /sprints/1
  # GET /sprints/1.xml
  def show
    @sprint = Sprint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sprint }
    end
  end

  # GET /sprints/new
  # GET /sprints/new.xml
  def new
    @sprint = Sprint.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sprint }
    end
  end

  # GET /sprints/1/edit
  def edit
    @sprint = Sprint.find(params[:id])
  end

  # POST /sprints
  # POST /sprints.xml
  def create
    @sprint = Sprint.new(params[:sprint])

    respond_to do |format|
      if @sprint.save
        flash[:notice] = 'Sprint was successfully created.'
        format.html { redirect_to(@sprint) }
        format.xml  { render :xml => @sprint, :status => :created, :location => @sprint }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sprint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sprints/1
  # PUT /sprints/1.xml
  def update
    @sprint = Sprint.find(params[:id])

    respond_to do |format|
      if @sprint.update_attributes(params[:sprint])
        flash[:notice] = 'Sprint was successfully updated.'
        format.html { redirect_to(@sprint) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sprint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sprints/1
  # DELETE /sprints/1.xml
  def destroy
    @sprint = Sprint.find(params[:id])
    @sprint.destroy

    respond_to do |format|
      format.html { redirect_to(sprints_url) }
      format.xml  { head :ok }
    end
  end
end
