class Story < ActiveRecord::Base
	acts_as_list
	belongs_to :project
	has_and_belongs_to_many :sprints
  has_many :tasks

	validates_presence_of :title, :as_a, :i_want_to, :so_i_can
	validates_associated :project


end
