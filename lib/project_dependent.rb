module ProjectDependent
	protected

	def load_project
    @project = Project.find(params[:project_id])
  end
end
