class WikisController < ApplicationController
  include ProjectDependent
  before_filter :require_authentication, :load_project

  # GET /wikis
  # GET /wikis.xml
  def index
    @wikis = @project.wikis

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @wikis }
    end
  end

  # GET /wikis/1
  # GET /wikis/1.xml
  def show
    @wiki =  @project.wikis.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @wiki }
    end
  end

  # GET /wikis/new
  # GET /wikis/new.xml
  def new
    @wiki = Wiki.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @wiki }
    end
  end

  # GET /wikis/1/edit
  def edit
    @wiki =  @project.wikis.find(params[:id])
  end

  # POST /wikis
  # POST /wikis.xml
  def create
    @wiki = Wiki.new(params[:wiki])
    @project.wikis << @wiki

    respond_to do |format|
      if @wiki.save
        flash[:notice] = 'Wiki was successfully created.'
        format.html { redirect_to project_wiki_path(@project, @wiki) }
        format.xml  { render :xml => @wiki, :status => :created, :location => @wiki }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @wiki.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /wikis/1
  # PUT /wikis/1.xml
  def update
    @wiki = @project.wikis.find(params[:id])

    respond_to do |format|
      if @wiki.update_attributes(params[:wiki])
        flash[:notice] = 'Wiki was successfully updated.'
        format.html { redirect_to project_wiki_path(@project, @wiki) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @wiki.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /wikis/1
  # DELETE /wikis/1.xml
  def destroy
    @wiki = @project.wikis.find(params[:id])
    @project.wikis.delete(@wiki)
    @wiki.destroy

    respond_to do |format|
      format.html { redirect_to project_wikis_path(@project) }
      format.xml  { head :ok }
    end
  end
end
