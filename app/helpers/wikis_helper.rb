module WikisHelper
	def write_redCloth(body)
		r = RedCloth.new body
		r.to_html
	end
end
