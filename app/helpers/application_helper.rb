module ApplicationHelper
	def current_page(path)
		current_route = Rails.application.routes.recognize_path(path)
		"active" if current_page?(path) or params[:controller] == current_route[:controller]
  end
end
