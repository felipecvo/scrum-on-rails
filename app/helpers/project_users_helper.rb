module ProjectUsersHelper
	def exist_in_list(project_users, user)
		@controller.exist_in_list(project_users, user)
	end

	def get_project_user_by_user(project_users, user)
		@controller.get_project_user_by_user(project_users, user)
	end

end
