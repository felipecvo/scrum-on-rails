module ProjectDependent
	protected

	def load_project
    @project = Project.find(params[:project_id])
  end

	def self.included(base)
		base.before_filter(:load_project)
	end

end
