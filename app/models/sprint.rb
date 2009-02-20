class Sprint < ActiveRecord::Base
	has_and_belongs_to_many :stories
	acts_as_list
	belongs_to :project
	validates_presence_of :goal

	class << self
		def create_new(project)
			sprint = self.new
			sprint.start_date = Date.today
	    sprint.end_date =  sprint.start_date + project.sprint_duration_days
			sprint
		end

		def create_next(previous_sprint)
			sprint = self.new
			sprint.start_date = previous_sprint.end_date + 1.days
		  sprint.end_date =  sprint.start_date + previous_sprint.project.sprint_duration_days
			sprint
		end
	end

	def current?
		self[:start_date] <= Date.today && self[:end_date] >= Date.today
	end

	def total_estimate
		self.stories.sum(:estimate)
	end

	def total_remaining_at(date)
		total_finished = 0

		for story in stories
			done_at = story.done_at
			if !done_at.nil? && done_at <= date
				total_finished += story.estimate
			end
		end

		total = total_estimate - total_finished
		return total
	end
end
