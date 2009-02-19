class Story < ActiveRecord::Base
	acts_as_list
	belongs_to :project
	has_and_belongs_to_many :sprints
  has_many :tasks

	validates_presence_of :title, :as_a, :i_want_to, :so_i_can
	validates_associated :project



	def tasks_todo
		items = self.tasks.select do |item|
	    item.status == "TODO"
    end
		return items
	end

	def tasks_working
		items = self.tasks.select do |item|
	    item.status == "WORKING"
    end
		return items
	end

	def tasks_done
		items = self.tasks.select do |item|
	    item.status == "DONE"
    end
		return items
	end
end
