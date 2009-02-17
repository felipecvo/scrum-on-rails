class Story < ActiveRecord::Base
	belongs_to :project

	acts_as_list
end
