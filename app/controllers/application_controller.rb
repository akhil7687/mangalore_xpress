class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, if: Proc.new {|c| c.request.format.json? }

  protected
  def after_sign_in_path_for(resource)
  	if current_user.is_admin?
    	admin_dashboard_path || root_path
  	else
  		stored_location_for(resource) || super
  	end
  end
end
