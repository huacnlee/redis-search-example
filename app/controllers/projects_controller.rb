class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.order("id desc").limit(20)
    @project = Project.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  def search
    if params[:q].blank?
      render :text => ""
      return
    end
    params[:q].gsub!(/'/,'')
    @search = Redis::Search.complete("Project", params[:q])
    lines = @search.collect do |item|
      puts item
      "#{escape_javascript(item['title'])}#!##{item['url']}#!##{item['lanuage']}#!##{item['watchers']}#!##{escape_javascript(item['description'])}"
    end
    render :text => lines.join("\n")
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.fetch_from_github(params[:project][:full_name])

    if @project
      redirect_to projects_path, notice: 'Project was successfully created.'
    else
      redirect_to projects_path, alert: "Fetch failed, try again."
    end
  end

end
