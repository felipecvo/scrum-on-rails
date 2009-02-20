class Story < ActiveRecord::Base
	acts_as_list
	belongs_to :project
	has_and_belongs_to_many :sprints
  has_many :tasks

	validates_presence_of :title, :as_a, :i_want_to, :so_i_can
	validates_associated :project

	def done?
		self.tasks_done.length == self.tasks.length
  end

  def done_at
  	if done?
  		tasks_copy = Marshal.load( Marshal.dump( tasks ) )
	  	tasks_copy.sort {|x,y| x.updated_at <=> y.updated_at }
	  	date = tasks_copy.last.updated_at

			return Date.new(date.year, date.month, date.day)
	  end
	  return nil
 	end

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
