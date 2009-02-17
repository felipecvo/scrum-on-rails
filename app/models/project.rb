class Project < ActiveRecord::Base
	has_many :project_users
	has_many :stories, :order => "position"

	def current_sprint_stories
		self.stories
	end

end
